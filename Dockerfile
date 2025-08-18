FROM ghcr.io/linuxserver/baseimage-guacgui

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

ENV APPNAME="rmlint" UMASK_SET="022"

RUN \
 echo "**** install rmlint ****" && \
 apt update && \
 apt install -y jq && \
 latest_tag=$(curl -s https://api.github.com/repos/bobbintb/docker-rmlint-unraid/releases/latest | jq -r .tag_name) && \
 wget "https://github.com/bobbintb/docker-rmlint-unraid/releases/latest/download/rmlint_${latest_tag#v}_amd64.deb" && \
 apt install ./rmlint*.deb && \
 rm -rf /var/lib/apt/lists && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /
