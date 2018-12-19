#!/bin/bash

chown -Rf www-data.www-data /var/www/html


if [ ! -z "$MAX_CHILDREN" ]; then
 sed -i "s/pm.max_children = 5/pm.max_children = ${MAX_CHILDREN}/g" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$START_SERVERS" ]; then
 sed -i "s/pm.start_servers = 2/pm.start_servers = ${START_SERVERS}/g" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$MIN_SPARE_SERVERS" ]; then
 sed -i "s/pm.min_spare_servers = 1/pm.min_spare_servers = ${MIN_SPARE_SERVERS}/g" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$MAX_SPARE_SERVERS" ]; then
 sed -i "s/pm.max_spare_servers = 3/pm.max_spare_servers = ${MAX_SPARE_SERVERS}/g" /usr/local/etc/php-fpm.d/www.conf
fi

if [ ! -z "$PHP_POST_MAX_SIZE" ]; then
 sed -i "s/post_max_size = 100M/post_max_size = ${PHP_POST_MAX_SIZE}M/g" /usr/local/etc/php-fpm.d/www.conf
fi

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
