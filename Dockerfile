FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG RMLINT_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="bobbintb"

# title
ENV TITLE=rmlint \
    NO_GAMEPAD=true \
    CUSTOM_PORT=8321 \
    CUSTOM_HTTPS_PORT=8322

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  wget \
  jq \
  python3-gi \
  gir1.2-gtk-3.0 \
  gir1.2-rsvg-2.0 \
  librsvg2-common \
  gir1.2-gtksource-4 \
  python3-cairo \
  python3-gi-cairo && \
  latest_tag=$(curl -s https://api.github.com/repos/bobbintb/docker-rmlint-unraid/releases/latest | jq -r .tag_name) && \
  wget "https://github.com/bobbintb/docker-rmlint-unraid/releases/latest/download/rmlint_${latest_tag#v}_amd64.deb" && \
  apt install ./rmlint*.deb && \
  echo "**** openbox tweaks ****" && \
  sed -i \
    's/NLIMC/NLMC/g' \
    /etc/xdg/openbox/rc.xml && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /config/.launchpadlib \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 8321 8322

VOLUME /config
