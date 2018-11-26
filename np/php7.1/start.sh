#!/bin/bash

chown -Rf nginx.nginx /var/www/html

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
