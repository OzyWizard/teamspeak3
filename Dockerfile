FROM alpine:3.7
MAINTAINER fithwum

# URL's for files
ARG INSTALL_SCRIPT=https://raw.githubusercontent.com/fithwum/teamspeak3/master/files/Install_Script.sh

# Install dependencies and folder creation
RUN apk add --no-cache ca-certificates libstdc++ su-exec tar \
	&& mkdir -p -v /ts3server \
	&& mkdir -p -v /ts3temp \
	&& chmod 777 -R -v /ts3server \
	&& chown 99:100 -R -v /ts3server \
	&& chmod 777 -R -v /ts3temp \
	&& chown 99:100 -R -v /ts3temp \
	&& wget "${INSTALL_SCRIPT}" -O /ts3temp/Install_Script.sh \
	&& chmod +x -v /ts3temp/Install_Script.sh

# directory where data is stored
VOLUME /ts3server
WORKDIR /ts3server

# 9987 default voice, 10011 server query, 30033 file transport
EXPOSE 9987/udp 10011/tcp 30033/tcp

# Run command
CMD ["/bin/sh", "/ts3temp/Install_Script.sh"]
