#!/bin/bash

DATA_DIRECTORY=/data/toran-proxy
WORK_DIRECTORY=/var/www
ASSETS_DIRECTORY=/assets
BIN_DIRECTORY=/bin/toran-proxy

# Initilisation
source $BIN_DIRECTORY/install/toran.sh
source $BIN_DIRECTORY/install/nginx.sh
source $BIN_DIRECTORY/install/ssh.sh

if [ $HTTP_PROXY ]; then
	echo "env[HTTP_PROXY] = $HTTP_PROXY" >> /etc/php5/fpm/pool.d/www.conf
fi

if [ $HTTPS_PROXY ]; then
	echo "env[HTTPS_PROXY] = $HTTPS_PROXY" >> /etc/php5/fpm/pool.d/www.conf
fi

# Start PHP-FPM
echo "Starting PHP-FPM..."
php5-fpm -R

# Start Cron
if [ "${TORAN_CRON}" == true ]; then
	echo "Starting Cron..."
	source $BIN_DIRECTORY/cron/toran-proxy.sh
	cron
fi

# Start Nginx
echo "Starting Nginx..."
nginx -c /etc/nginx/nginx.conf
