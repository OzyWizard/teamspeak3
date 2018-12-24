FROM alpine:3.8
MAINTAINER fithwum

RUN useradd --uid 99 --gid 100 docker

RUN apk add --no-cache ca-certificates libstdc++ su-exec
RUN set -eux; \
	addgroup -g 100 ts3server; \
	adduser -u 99 -Hh /ts3server -G ts3server -s /sbin/nologin -D ts3server; \
	mkdir -p /ts3server; \
	chown ts3server:ts3server /ts3server; \
	chmod 777 /ts3server

ENV PATH "${PATH}:/ts3server"

ARG TEAMSPEAK_CHECKSUM=9f95621a70ebd4822e1c918ccea15bfc8e83da15358c820422dda5a142ae79e1
ARG TEAMSPEAK_URL=http://dl.4players.de/ts/releases/3.5.1/teamspeak3-server_linux_alpine-3.5.1.tar.bz2

RUN set -eux; \
	apk add --no-cache --virtual .fetch-deps tar; \
	wget "${TEAMSPEAK_URL}" -O server.tar.bz2; \
	echo "${TEAMSPEAK_CHECKSUM} *server.tar.bz2" | sha256sum -c -; \
	tar -xf server.tar.bz2 --strip-components=1 -C /ts3server; \
	rm server.tar.bz2; \
	apk del .fetch-deps

# setup directory where user data is stored
VOLUME ["/ts3server"]
WORKDIR /ts3server

#  9987 default voice
# 10011 server query
# 30033 file transport
EXPOSE 9987/udp 10011 30033

COPY /files/ts3db_mariadb.ini /ts3server/ts3db_mariadb.ini
COPY /files/ts3server.ini /ts3server/ts3server.ini
COPY /files/ts3server_startscript.sh /ts3server/ts3server_startscript.sh
CMD [ "/ts3server/ts3server_startscript.sh" ]
