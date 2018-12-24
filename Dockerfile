FROM alpine:3.8
MAINTAINER fithwum

RUN apk add --no-cache ca-certificates libstdc++ su-exec
RUN set -eux; \
	addgroup -g 9987 ts3server; \
	adduser -u 9987 -Hh /ts3server -G ts3server -s /sbin/nologin -D ts3server; \
	mkdir -p /ts3server; \
	chown ts3server:ts3server /ts3server; \
	chmod 777 /ts3server

COPY install.sh /install.sh

CMD {"/install.sh"}

ENV PATH "${PATH}:/ts3server"

# setup directory where user data is stored
VOLUME /ts3server
WORKDIR /ts3server

#  9987 default voice
# 10011 server query
# 30033 file transport
EXPOSE 9987/udp 10011 30033

COPY /files/ts3db_mariadb.ini /ts3server/ts3db_mariadb.ini
COPY /files/ts3server.ini /ts3server/ts3server.ini
COPY /files/ts3server_startscript.sh /ts3server/ts3server_startscript.sh
CMD [ "/ts3server/ts3server_startscript.sh" ]
