#!/bin/bash

DATA_DIRECTORY=/data/toran-proxy
WORK_DIRECTORY=/var/www
ASSETS_DIRECTORY=/assets
SCRIPTS_DIRECTORY=/scripts/toran-proxy

# Create logs directory
if [ -d $DATA_DIRECTORY/logs ]; then
    rm -rf $DATA_DIRECTORY/logs
fi

# Initilisation
source $SCRIPTS_DIRECTORY/install/php-fpm.sh
source $SCRIPTS_DIRECTORY/install/nginx.sh
source $SCRIPTS_DIRECTORY/install/ssh.sh
source $SCRIPTS_DIRECTORY/install/toran.sh

# Start services
echo "Starting Toran Proxy..."
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
