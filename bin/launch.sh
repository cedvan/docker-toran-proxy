#!/bin/bash

DATA_DIRECTORY=/data/toran-proxy
WORK_DIRECTORY=/var/www
ASSETS_DIRECTORY=/assets
BIN_DIRECTORY=/bin/toran-proxy

# Initilisation
source $BIN_DIRECTORY/install/php.sh
source $BIN_DIRECTORY/install/nginx.sh
source $BIN_DIRECTORY/install/ssh.sh
source $BIN_DIRECTORY/install/toran.sh

# Start PHP-FPM
echo "Starting PHP-FPM..."
php5-fpm -R

# Start Cron
echo "Starting Cron Service..."
cron

# Start Nginx
echo "Starting Nginx..."
nginx -c /etc/nginx/nginx.conf
