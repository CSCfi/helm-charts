#!/bin/bash

set -e

cp /etc/passwd /tmp/passwd
sed -i "s/^rstudio-server:x:\([0-9]*\):\([0-9]*\)/rstudio-server:x:$(id -u):$(id -u)/" /tmp/passwd

export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group
export USER=rstudio-server

echo "Starting RStudio Server"

# Increase ulimits to 16Gb
ulimit -s 16384
# Run rserver via script, since it only outputs error when terminal is attached.
# -e/--return makes script exit with rserver's own exit code instead of always 0.
script -qe -c "/usr/lib/rstudio-server/bin/rserver" /dev/stdout &
RSERVER_PID=$!

echo "Copy Shiny samples to mounted volume"
cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/
cp -R /opt/shiny-server/samples/* /srv/shiny-server/
mv /srv/shiny-server/welcome.html /srv/shiny-server/index.html

echo "Starting Shiny Server"
# Send Shiny's own log to stdout too, so a crash is visible in `oc logs`
# instead of only inside the container's filesystem.
shiny-server >>/var/log/shiny-server/server.log 2>&1 &
SHINY_PID=$!

# Forward termination signals to both children so a normal `oc delete pod`/
# rollout shuts them down cleanly instead of getting SIGKILLed by tini.
shutdown() {
  trap - TERM INT
  echo "Caught termination signal, stopping RStudio Server and Shiny Server"
  kill -TERM "$RSERVER_PID" "$SHINY_PID" 2>/dev/null || true
  wait "$RSERVER_PID" "$SHINY_PID" 2>/dev/null || true
  exit 0
}
trap shutdown TERM INT

# Wait for whichever of the two servers exits first. Previously this was a
# plain `sleep inf`, so if either server crashed the container kept running
# and reporting healthy, which was confusing for both users and admins.
# Now: as soon as one dies, stop the other and exit non-zero so the pod
# actually fails and OKD (and `oc get pods`) reflects reality.
set +e
wait -n "$RSERVER_PID" "$SHINY_PID"
EXIT_CODE=$?
set -e

if kill -0 "$RSERVER_PID" 2>/dev/null; then
  echo "Shiny Server exited unexpectedly (exit code $EXIT_CODE), stopping RStudio Server"
  kill -TERM "$RSERVER_PID"
else
  echo "RStudio Server exited unexpectedly (exit code $EXIT_CODE), stopping Shiny Server"
  kill -TERM "$SHINY_PID"
fi

wait || true
exit "$EXIT_CODE"
