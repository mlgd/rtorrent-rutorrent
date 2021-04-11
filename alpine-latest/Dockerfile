FROM alpine:latest
USER root

ENV DHT_PORT=49160
ENV INCOMING_PORT=49161-49161
ENV USR_ID=1000
ENV GRP_ID=1000
ENV PHP_MEM=256M
ENV HTTP_PORT=80
ENV HTTPS_PORT=443

RUN apk -U upgrade && \
    apk add --no-cache rtorrent mediainfo unzip unrar curl php7-fpm php7 php7-json php7-zip nginx wget ffmpeg supervisor git sox irssi && \
    apk add --no-cache py3-pip gcc g++ musl-dev libffi-dev openssl-dev && \
    pip install cloudscraper && \
    apk del py-pip gcc g++ musl-dev libffi-dev openssl-dev && \
    rm -rf /var/cache/apk/* && \
    git clone https://github.com/mlgd/rtorrent-rutorrent.git a && \
    mkdir -p /var/www && cd /var/www && \
    git clone https://github.com/Novik/ruTorrent.git rutorrent && \
    rm -rf ./rutorrent/.git* && cd / && \
    cp ./a/_shared/alpine/rutorrent/config.php /var/www/rutorrent/conf/ && \
    cp ./a/_shared/alpine/startup/startup-rtorrent.sh ./a/_shared/alpine/startup/startup-nginx.sh ./a/_shared/alpine/startup/startup-php.sh ./a/_shared/alpine/rtorrent/.rtorrent.rc /root/ && \
    mkdir -p /etc/supervisor.d && \
    cp ./a/_shared/alpine/supervisord/supervisord.ini /etc/supervisor.d/supervisord.ini && \
    mkdir -p /etc/nginx/sites-enabled && \
    cp ./a/_shared/alpine/nginx/nginx.conf /etc/nginx/ && \
    # cp ./a/_shared/alpine/php-fpm.conf /etc/php7/ && \
    cp ./a/_shared/alpine/nginx/rutorrent-*.nginx /root/

VOLUME /downloads

CMD ["supervisord"]
