FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG RMLINT_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="bobbintb"

# title
ENV TITLE=rmlint \
    NO_GAMEPAD=true

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  latest_tag=$(curl -s https://api.github.com/repos/bobbintb/docker-rmlint-unraid/releases/latest | jq -r .tag_name) && \
  wget "https://github.com/bobbintb/docker-rmlint-unraid/releases/latest/download/rmlint_${latest_tag#v}_amd64.deb" && \
  apt install ./rmlint*.deb && \

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
EXPOSE 8322

VOLUME /config
