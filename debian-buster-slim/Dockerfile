FROM debian:buster-slim
USER root

ENV DHT_PORT=49160
ENV INCOMING_PORT=49161-49161
ENV USR_ID=1000
ENV GRP_ID=1000
ENV PHP_MEM=256M
ENV HTTP_PORT=80
ENV HTTPS_PORT=443

RUN apt update && apt upgrade -y && \
    apt install -y git && \
    git clone  https://github.com/mlgd/rtorrent-rutorrent-common.git common && \
    cp ./common/sources/debian-extra.list /etc/apt/sources.list.d/extra.list && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y rtorrent unzip unrar mediainfo curl php-fpm php-cli php-geoip php-mbstring php-zip nginx wget ffmpeg supervisor php-xml libarchive-zip-perl libjson-perl libxml-libxml-perl irssi sox python3-pip && \
    pip3 install cloudscraper && \
    rm -rf /var/lib/apt/lists/* && \
    cp ./common/nginx/rutorrent-*.nginx /root/ && \
    mkdir -p /var/www && cd /var/www && \
    git clone https://github.com/Novik/ruTorrent.git rutorrent && \
    rm -rf ./rutorrent/.git* && cd / && \
    cp ./common/rutorrent/config.php /var/www/rutorrent/conf/ && \
    cp ./common/startup/startup-rtorrent.sh ./common/startup/startup-nginx.sh ./common/startup/startup-php.sh ./common/startup/startup-irssi.sh ./common/rtorrent/.rtorrent.rc /root/ && \
    chmod +x /root/*.sh && \
    cp ./common/supervisord/supervisord.conf /etc/supervisor/conf.d/ && \
    sed -i 's/\/var\/log/\/downloads\/\.log/g' /etc/nginx/nginx.conf

VOLUME /downloads

CMD ["supervisord"]