#!/usr/bin/env sh

set -x

RT_INCOMING_PORT=${INCOMING_PORT:=49161-49161}
RT_DHT_PORT=${DHT_PORT:=49160}
RT_SCGI_PORT=${SCGI_PORT:=5000}

# set rtorrent user and group id
RT_UID=${USR_ID:=1000}
RT_GID=${GRP_ID:=1000}

# update uids and gids
groupadd -g $RT_GID rtorrent
useradd -u $RT_UID -g $RT_GID -d /home/rtorrent -m -s /bin/bash rtorrent

# arrange dirs and configs
mkdir -p /downloads/.rtorrent/session 
mkdir -p /downloads/.rtorrent/watch
mkdir -p /downloads/.log/rtorrent
if [ ! -e /downloads/.rtorrent/.rtorrent.rc ]; then
    cp /root/.rtorrent.rc /downloads/.rtorrent/
    sed -i 's/scgi_port=127\.0\.0\.1:5000$/scgi_port=127.0.0.1:'$RT_SCGI_PORT'/g' /downloads/.rtorrent/.rtorrent.rc
    sed -i 's/network\.port_range\.set *=.*$/network.port_range.set = '$RT_INCOMING_PORT'/g' /downloads/.rtorrent/.rtorrent.rc
    sed -i 's/network\.port_random\.set *=.*$/network.port_random.set = no/g' /downloads/.rtorrent/.rtorrent.rc
    sed -i 's/dht\.port\.set *=.*$/dht.port.set = '$RT_DHT_PORT'/g' /downloads/.rtorrent/.rtorrent.rc
    sed -i 's/scgi_port *= *5000;/cgi_port = '$RT_SCGI_PORT';/g' /var/www/rutorrent/conf/config.php
fi
ln -s /downloads/.rtorrent/.rtorrent.rc /home/rtorrent/
chown -R rtorrent:rtorrent /downloads/.rtorrent
chown -R rtorrent:rtorrent /home/rtorrent
chown -R rtorrent:rtorrent /downloads/.log/rtorrent

rm -f /downloads/.rtorrent/session/rtorrent.lock

# run
su --login --command="TERM=xterm rtorrent" rtorrent 
