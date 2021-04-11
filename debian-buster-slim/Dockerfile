FROM debian:buster-slim
USER root

ENV DHT_PORT=49160
ENV INCOMING_PORT=49161-49161
ENV USR_ID=1000
ENV GRP_ID=1000
ENV SCGI_PORT=5000
ENV PHP_MEM=256M
ENV HTTP_PORT=80
ENV HTTPS_PORT=443

RUN apt update && apt upgrade -y && \
    apt install -y git && \
    git clone https://github.com/mlgd/rtorrent-rutorrent.git a && \
    cp ./a/_shared/debian/sources/debian-extra.list /etc/apt/sources.list.d/extra.list && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y rtorrent unzip unrar mediainfo curl php-fpm php-cli php-geoip php-mbstring php-zip nginx wget ffmpeg supervisor php-xml libarchive-zip-perl libjson-perl libxml-libxml-perl irssi sox python3-pip && \
    pip3 install cloudscraper && \
    rm -rf /var/lib/apt/lists/* && \
    cp ./a/_shared/debian/nginx/rutorrent-*.nginx /root/ && \
    mkdir -p /var/www && cd /var/www && \
    git clone https://github.com/Novik/ruTorrent.git rutorrent && \
    rm -rf ./rutorrent/.git* && cd / && \
    cp ./a/_shared/debian/rutorrent/config.php /var/www/rutorrent/conf/ && \
    cp ./a/_shared/debian/startup/startup-rtorrent.sh ./a/_shared/debian/startup/startup-nginx.sh ./a/_shared/debian/startup/startup-php.sh ./a/_shared/debian/startup/startup-irssi.sh ./a/_shared/debian/rtorrent/.rtorrent.rc /root/ && \
    chmod +x /root/*.sh && \
    cp ./a/_shared/debian/supervisord/supervisord.conf /etc/supervisor/conf.d/ && \
    sed -i 's/\/var\/log/\/downloads\/\.log/g' /etc/nginx/nginx.conf

VOLUME /downloads

CMD ["supervisord"]