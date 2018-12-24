#! /bin/sh

ARG TEAMSPEAK_CHECKSUM=9f95621a70ebd4822e1c918ccea15bfc8e83da15358c820422dda5a142ae79e1
ARG TEAMSPEAK_URL=http://dl.4players.de/ts/releases/3.5.1/teamspeak3-server_linux_alpine-3.5.1.tar.bz2

RUN set -eux; \
	apk add --no-cache --virtual .fetch-deps tar; \
	wget "${TEAMSPEAK_URL}" -O server.tar.bz2; \
	echo "${TEAMSPEAK_CHECKSUM} *server.tar.bz2" | sha256sum -c -; \
	tar -xf server.tar.bz2 --strip-components=1 -C /ts3server; \
	rm server.tar.bz2; \
	apk del .fetch-deps
