#!/usr/bin/env sh

set -x

NG_HTTP_PORT=${HTTP_PORT:=80}
RT_SCGI_PORT=${SCGI_PORT:=5000}

chown -R www-data:www-data /var/www/rutorrent
cp /downloads/.htpasswd /var/www/rutorrent/
mkdir -p /downloads/.rutorrent/torrents
chown -R www-data:www-data /downloads/.rutorrent
mkdir -p /downloads/.log/nginx
chown www-data:www-data /downloads/.log/nginx

rm -f /etc/nginx/sites-enabled/*

rm -rf /etc/nginx/ssl

rm /var/www/rutorrent/.htpasswd


# Basic auth enabled by default
site=rutorrent-basic.nginx

# Check if TLS needed
if [ -e /downloads/nginx.key ] && [ -e /downloads/nginx.crt ]; then
    mkdir -p /etc/nginx/ssl
    cp /downloads/nginx.crt /etc/nginx/ssl/
    cp /downloads/nginx.key /etc/nginx/ssl/
    site=rutorrent-tls.nginx
fi

if [ ! -e /etc/nginx/sites-enabled/$site ]; then
    cp /root/$site /etc/nginx/sites-enabled/
    sed -i 's/listen 80 default_server/listen '$NG_HTTP_PORT' default_server/g' /etc/nginx/sites-enabled/$site
    sed -i 's/listen \[::\]:80 default_server/listen [::]:'$NG_HTTP_PORT' default_server/g' /etc/nginx/sites-enabled/$site
    sed -i 's/scgi_pass 127\.0\.0\.1:5000;/scgi_pass 127.0.0.1:'$RT_SCGI_PORT';/g' /etc/nginx/sites-enabled/$site
    [ -n "$NOIPV6" ] && sed -i 's/listen \[::\]:/#/g' /etc/nginx/sites-enabled/$site
    [ -n "$WEBROOT" ] && ln -s /var/www/rutorrent /var/www/rutorrent/$WEBROOT
fi

# Check if .htpasswd presents
if [ -e /downloads/.htpasswd ]; then
    cp /downloads/.htpasswd /var/www/rutorrent/ && chmod 755 /var/www/rutorrent/.htpasswd && chown www-data:www-data /var/www/rutorrent/.htpasswd
else
# disable basic auth
    sed -i 's/auth_basic/#auth_basic/g' /etc/nginx/sites-enabled/$site
fi

nginx -g "daemon off;"
