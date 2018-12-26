FROM alpine:3.7
MAINTAINER fithwum

# URL's for files
ARG TEAMSPEAK_CHECKSUM=9f95621a70ebd4822e1c918ccea15bfc8e83da15358c820422dda5a142ae79e1; \
	TEAMSPEAK_URL=http://dl.4players.de/ts/releases/3.5.1/teamspeak3-server_linux_alpine-3.5.1.tar.bz2; \
	DB_FILE=https://github.com/fithwum/teamspeak3/blob/master/files/ts3db_mariadb.ini; \
	INI_FILE=https://github.com/fithwum/teamspeak3/blob/master/files/ts3server.ini; \
	START_SCRIPT=https://github.com/fithwum/teamspeak3/blob/master/files/ts3server_startscript.sh

# installs and Folder creation
RUN apk add --no-cache ca-certificates libstdc++ su-exec tar; \
	mkdir -p /ts3server; \
	chmod 777 /ts3server

# File downloading/unpacking
RUN wget "${TEAMSPEAK_URL}" -O server.tar.bz2; \
	echo "${TEAMSPEAK_CHECKSUM} *server.tar.bz2" | sha256sum -c -; \
	tar -xf server.tar.bz2 --strip-components=1 -C /ts3server; \
	rm server.tar.bz2; \
	wget "${DB_FILE}" -O /ts3server/ts3db_mariadb.ini; \
	wget "${INI_FILE}" -O /ts3server/ts3server.ini; \
	wget "${START_SCRIPT}" -O /ts3server/ts3server_startscript.sh

# directory where data is stored
VOLUME ["/ts3server"]

#  9987 default voice, 10011 server query, 30033 file transport
EXPOSE 9987/udp 10011 30033

# Run command
ENTRYPOINT ["/ts3server"]
CMD ["/ts3server/ts3server_startscript.sh"]
