FROM alpine:3.7
MAINTAINER fithwum

# URL's for files
ARG TEAMSPEAK_CHECKSUM=9f95621a70ebd4822e1c918ccea15bfc8e83da15358c820422dda5a142ae79e1
ARG TEAMSPEAK_URL=http://dl.4players.de/ts/releases/3.5.1/teamspeak3-server_linux_alpine-3.5.1.tar.bz2
ARG DB_FILE=https://raw.githubusercontent.com/fithwum/teamspeak3/master/files/ts3db_mariadb.ini
ARG INI_FILE=https://raw.githubusercontent.com/fithwum/teamspeak3/master/files/ts3server.ini
ARG RUN_SCRIPT=https://raw.githubusercontent.com/fithwum/teamspeak3/master/files/runserver.sh
ARG START_SCRIPT=https://raw.githubusercontent.com/fithwum/teamspeak3/master/files/ts3server_startscript.sh

# Installs dependencies and folder creation
RUN apk add --no-cache ca-certificates libstdc++ su-exec tar \
	&& mkdir -p -v /ts3server \
	&& chmod 777 -R -v /ts3server \
	&& chown 99:100 -R -v /ts3server \
	&& mkdir -p -v /ts3temp \
	&& chmod 777 -R -v /ts3temp \
	&& chown 99:100 -R -v /ts3temp

ENV PATH ${PATH}:/ts3server

# File downloading/unpacking
RUN wget "${TEAMSPEAK_URL}" -O server.tar.bz2 \
	&& echo "${TEAMSPEAK_CHECKSUM} *server.tar.bz2" | sha256sum -c - \
	&& tar -xf server.tar.bz2 --strip-components=1 -C /ts3temp \
	&& rm  -v server.tar.bz2 \
	&& wget "${DB_FILE}" -O /ts3temp/ts3db_mariadb.ini \
	&& wget "${INI_FILE}" -O /ts3temp/ts3server.ini \
	&& wget "${RUN_SCRIPT}" -O /ts3temp/runserver.sh \
	&& wget "${START_SCRIPT}" -O /ts3temp/ts3server_startscript.sh \
	&& mv /ts3temp/* /ts3server/ \
	&& chmod 777 -R /ts3server \
	&& chown 99:100 -R /ts3server \
	&& chmod +x -v /ts3server/ts3server_startscript.sh \
	&& chmod +x -v /ts3server/runserver.sh

# directory where data is stored
VOLUME /ts3server

# 9987 default voice, 10011 server query, 30033 file transport
EXPOSE 9987/udp 10011/tcp 30033/tcp

# Run command
CMD ["/bin/sh", "/ts3server/runserver.sh"]
