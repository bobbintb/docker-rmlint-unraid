FROM ghcr.io/linuxserver/baseimage-guacgui

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

ENV APPNAME="rmlint" UMASK_SET="022"

RUN \
 echo "**** install runtime packages ****" && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
	lxterminal \
	nano \
	wget \
	openssh-client \
	rsync \
	ca-certificates \
	xdg-utils \
	htop \
	tar \
	xzip \
	gzip \
	bzip2 \
	zip \
	unzip && \
 echo "**** install rmlint ****" && \
 apt-get install -y --no-install-recommends \
	git \
	scons \
	python3-sphinx \
	python3-gi-cairo \
	python3-nose \
	python-xdg \
	gettext build-essential && \
 echo "**** install optional dependencies for more features ****" && \
 apt-get install -y --no-install-recommends \
	libelf-dev \
	libglib2.0-dev \
	libblkid-dev \
	libjson-glib-1.0 \
	libjson-glib-dev && \
 echo "**** install optional dependencies for the GUI ****" && \
 apt-get install -y --no-install-recommends \
 	python3-gi \
	gir1.2-rsvg \
	gir1.2-gtk-3.0 \
	python3-cairo \
	gir1.2-polkit-1.0 \
	gir1.2-gtksource-3.0 \
	dbus-x11 \
	sudo && \
 git clone https://github.com/sahib/rmlint.git && \
 cd ./rmlint && \
 scons config && \
 scons DEBUG=1 && \
 echo "**** Install (and build if necessary). For releases you can omit DEBUG=1 ****" && \
 sudo scons DEBUG=1 --prefix=/usr install && \
 rm -rf /var/lib/apt/lists && \
 
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /
