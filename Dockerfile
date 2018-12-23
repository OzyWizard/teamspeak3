FROM alpine:3.8

MAINTAINER fithwum

RUN docker create
    -net="host" \
	-name=teamspeak3 \
	-v /mnt/user/appdata/teamspeak3:/ts3server \
	-e PGID=100 \
	-e PUID=99 \
	-e TS3SERVER_LICENSE= 

RUN apk add --no-cache ca-certificates libstdc++ su-exec
RUN set -eux; \
	addgroup -g 9987 ts3server; \
	adduser -u 9987 -Hh /ts3server -G ts3server -s /sbin/nologin -D ts3server; \
	mkdir -p /ts3server /ts3server; \
	chown ts3server:ts3server /ts3server; \
	chmod 777 /ts3server 

ENV PATH "${PATH}:/ts3server"

ARG TEAMSPEAK_CHECKSUM=9f95621a70ebd4822e1c918ccea15bfc8e83da15358c820422dda5a142ae79e1
ARG TEAMSPEAK_URL=http://dl.4players.de/ts/releases/3.5.1/teamspeak3-server_linux_alpine-3.5.1.tar.bz2

RUN set -eux; \
	apk add --no-cache --virtual .fetch-deps tar; \
	wget "${TEAMSPEAK_URL}" -O server.tar.bz2; \
	echo "${TEAMSPEAK_CHECKSUM} *server.tar.bz2" | sha256sum -c -; \
	mkdir -p /ts3server; \
	tar -xf server.tar.bz2 --strip-components=1 -C /ts3server; \
	rm server.tar.bz2; \
	apk del .fetch-deps; \
	mv /ts3server/*.so /ts3server/redist/* /usr/local/lib; \
	ldconfig /usr/local/lib; \
	chown -R ts3server:ts3server /ts3server

# setup directory where user data is stored
VOLUME /ts3server=

#  9987 default voice
# 10011 server query
# 30033 file transport
EXPOSE 9987/udp 10011 30033

COPY /files/ts3db_mariadb.ini /ts3server
COPY /files/ts3server.ini /ts3server
COPY /files/ts3server_startscript.sh /ts3server
ENTRYPOINT ["/ts3server"]
CMD [ "ts3server_startscript.sh" ]
