#!/usr/bin/env sh

set -x

MEM=${PHP_MEM:=256M}

sed -i 's/memory_limit.*$/memory_limit = '$MEM'/g' /etc/php/7.3/fpm/php.ini

mkdir /run/php
php-fpm7.3 --nodaemonize
