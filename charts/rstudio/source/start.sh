#!/bin/bash

set -e

cp /etc/passwd /tmp/passwd
sed -i "s/^rstudio-server:x:\([0-9]*\):\([0-9]*\)/rstudio-server:x:$(id -u):$(id -u)/" /tmp/passwd

export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group
export USER=rstudio-server

echo "Starting RStudio Server"

# Run rserver via script, since it only outputs error when terminal is attached
script -q -c "/usr/lib/rstudio-server/bin/rserver" /dev/stdout &

echo "Copy Shiny samples to mounted volume"
cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/
cp -R /opt/shiny-server/samples/* /srv/shiny-server/
mv /srv/shiny-server/welcome.html /srv/shiny-server/index.html

echo "Starting Shiny Server"
shiny-server > /var/log/shiny-server/server.log &

sleep inf
