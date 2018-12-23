# teamspeak3


docker create \
	--name=teamspeak3 \
	-v /mnt/user/appdata/teamspeak3:/ts3server \
	-e PGID=100 \
	-e PUID=99  \
	-e TS3SERVER_LICENSE= \
	fithwum/teamspeak3