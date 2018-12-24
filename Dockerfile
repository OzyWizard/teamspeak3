FROM alpine:3.8
MAINTAINER fithwum

RUN apk add --no-cache ca-certificates libstdc++ su-exec tar

RUN mkdir -p /ts3server
RUN chmod 777 /ts3server

ENV PATH "${PATH}:/ts3server"

ARG TEAMSPEAK_CHECKSUM=9f95621a70ebd4822e1c918ccea15bfc8e83da15358c820422dda5a142ae79e1
ARG TEAMSPEAK_URL=http://dl.4players.de/ts/releases/3.5.1/teamspeak3-server_linux_alpine-3.5.1.tar.bz2
ARG DB_FILE=https://github.com/fithwum/teamspeak3/blob/master/files/ts3db_mariadb.ini
ARG INI_FILE=https://github.com/fithwum/teamspeak3/blob/master/files/ts3server.ini
ARG START_SCRIPT=https://github.com/fithwum/teamspeak3/blob/master/files/ts3server_startscript.sh

RUN wget "${TEAMSPEAK_URL}" -O server.tar.bz2
RUN echo "${TEAMSPEAK_CHECKSUM} *server.tar.bz2" | sha256sum -c -

RUN tar -xf server.tar.bz2 --strip-components=1 -C /ts3server
RUN rm server.tar.bz2

RUN wget "${DB_FILE}" -O /ts3server/ts3db_mariadb.ini
RUN wget "${INI_FILE}" -O /ts3server/ts3server.ini
RUN wget "${START_SCRIPT}" -O /ts3server/ts3server_startscript.sh

# setup directory where user data is stored
VOLUME /ts3server

#  9987 default voice
# 10011 server query
# 30033 file transport
EXPOSE 9987/udp 10011 30033

CMD ["/ts3server/ts3server_startscript.sh"]
