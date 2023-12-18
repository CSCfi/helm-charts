FROM rocker/r-ver:4.3.2

ENV RSTUDIO_VERSION=2023.09.1+494
ENV PANDOC_VERSION=default

ENV PATH=/usr/lib/rstudio-server/bin:$PATH

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_shiny_server.sh

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y \
    apt-utils \
    libnss-wrapper \
    libnode72 \
    libbz2-dev \
    liblzma-dev \
    librsvg2-dev \
    strace \
    nano && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup various variables
ENV TZ="Europe/Helsinki" \
    USERNAME="rstudio" \
    HOME="/home/rstudio" \
    TINI_VERSION=v0.19.0 \
    APP_UID=999 \
    APP_GID=999 \
    PKG_R_VERSION=4.3.1 \
    PKG_RSTUDIO_VERSION=2023.09.1+494 \
    PKG_SHINY_VERSION=1.5.21.1012

# Setup Tini, as S6 does not work when run as non-root users
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /sbin/tini
RUN chmod +x /sbin/tini

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf

RUN install2.r -e shiny rmarkdown shinythemes shinydashboard && \
    mkdir -p /var/log/shiny-server && \
    chown rstudio:rstudio /var/log/shiny-server && \
    chmod go+w -R /var/log/shiny-server /usr/local/lib/R /srv /var/lib/shiny-server && \
    chmod ugo+rwx -R /usr/lib/rstudio-server/www

COPY start.sh /usr/local/bin/start.sh

RUN rstudio-server verify-installation

RUN chmod -R go+rwX /home /home/rstudio /tmp/downloaded_packages /var/run/rstudio-server /var/lib/rstudio-server /var/log/rstudio && \
    rm /var/lib/rstudio-server/rstudio-os.sqlite /var/run/rstudio-server/rstudio-rsession/rstudio-server-d.pid

USER $APP_UID:$APP_GID
WORKDIR $HOME
EXPOSE 8787 3838

ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD ["/usr/local/bin/start.sh"]
