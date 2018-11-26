#!/bin/sh

chown -Rf www-data.www-data /var/www/html

sed -i 's/pm.max_children = 5/pm.max_children = $MAX_CHILDREN/g' /usr/local/etc/php-fpm.d/www.conf
sed -i 's/pm.start_servers = 2/pm.start_servers = $START_SERVERS/g' /usr/local/etc/php-fpm.d/www.conf
sed -i 's/pm.min_spare_servers = 1/pm.min_spare_servers = $MIN_SPARE_SERVERS/g' /usr/local/etc/php-fpm.d/www.conf
sed -i 's/pm.max_spare_servers = 3/pm.max_spare_servers = $MAX_SPARE_SERVERS/g' /usr/local/etc/php-fpm.d/www.conf

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
