#!/bin/bash

chown -Rf www-data.www-data /var/www/html

/usr/bin/supervisord -n -c /etc/supervisord.conf
