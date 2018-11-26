#!/bin/sh

chown -Rf www-data.www-data /var/www/html

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
