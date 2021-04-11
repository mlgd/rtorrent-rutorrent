# Docker container with rTorrent and ruTorrent

Alpine-based tags:

- rtorrent-rutorrent:alpine-latest

Debian-based tags:

- rtorrent-rutorrent:debian-buster-slim

## Environment variables

- DHT_PORT: DHT UDP port, default is 49160
- INCOMING_PORT: incoming TCP port range, default is 49161-49161
- USR_ID: rtorrent uid, default is 1000 
- GRP_ID: rtorrent gid, default is 1000
- HTTP_PORT: NGINX http port, default 80
- HTTPS_PORT: NGINX https port, default 443
- PHP_MEM: php-fpm memory limit, default is 256M
- NOIPV6: disable IPv6 binding in nginx (set to 1), default is not set
- WEBROOT: alternative webroot, default is /

## Volumes exposed

- /downloads: folder containing downloaded files

## Run container 

> docker run -d --name=seedbox \\\
>       --expose=49161/tcp -p 49161:49161/tcp -e INCOMING_PORT=49161-49161 \\\
>       --expose=49160/udp -p 49160:49160/udp -e DHT_PORT=49160 \\\
>       --expose=80/tcp -p 80:80/tcp -e HTTP_PORT=80 \\\
>       --expose=443/tcp -p 443:443/tcp -e HTTPS_PORT=443 \\\
>       -e USR_ID=1000 \\\
>       -e GRP_ID=1000 \\\
>       -e PHP_MEM=256M \\\
>       -v c:\temp:/downloads \\\
>       mlgd/rtorrent-rutorrent:debian-buster-slim

## Windows 10 development : port access denied

> net stop winnat
>
> docker start ...
>
> net start winnat
