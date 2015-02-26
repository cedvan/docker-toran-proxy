#!/bin/bash

WORK_DIRECTORY=/var/www
BIN_DIRECTORY=/bin/toran-proxy

# Configuration
source $BIN_DIRECTORY/config.sh

# Initilisation
if [ "$TORAN_PROXY_INIT" == "false" ]; then
    source $BIN_DIRECTORY/install/nginx.sh
    source $BIN_DIRECTORY/install/toran.sh
    source $BIN_DIRECTORY/install/settings.sh
    sed -i "s/TORAN_PROXY_INIT=false/TORAN_PROXY_INIT=true/g" $BIN_DIRECTORY/config.sh
fi

# Start PHP-FPM
php5-fpm -R

# Start Nginx
nginx -c /etc/nginx/nginx.conf

# Start Cron
php $WORK_DIRECTORY/bin/cron -v