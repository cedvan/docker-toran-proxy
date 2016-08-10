#!/bin/bash

DATA_DIRECTORY=/data/toran-proxy
WORK_DIRECTORY=/var/www
ASSETS_DIRECTORY=/assets
SCRIPTS_DIRECTORY=/scripts/toran-proxy

# Create logs directory
if [ -d $DATA_DIRECTORY/logs ]; then
    rm -rf $DATA_DIRECTORY/logs
fi
mkdir $DATA_DIRECTORY/logs

# Initilisation
source $SCRIPTS_DIRECTORY/install/php.sh
source $SCRIPTS_DIRECTORY/install/nginx.sh
source $SCRIPTS_DIRECTORY/install/ssh.sh
source $SCRIPTS_DIRECTORY/install/toran.sh

# Loading logs permissions
chown -R www-data:www-data \
    $DATA_DIRECTORY/logs \

# Start services
echo "Starting Toran Proxy..."
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
