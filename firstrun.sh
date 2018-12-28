#!/bin/bash

if [ ! -d /ts3server/ ]; then
	echo '******MOVING**********'
	mv /usr/share/openhab/addons /ts3server/
	mv /usr/share/openhab/webapps /ts3server/
	mv /etc/openhab/configurations /ts3server/﻿
	chown nobody:users -R /ts3server
	chmod 777 -R /ts3server
fi


PUT IN DOCKERFILE

ADD firstrun.sh /etc/my_init.d/firstrun.sh
RUN chmod +x /etc/my_init.d/firstrun.sh﻿
