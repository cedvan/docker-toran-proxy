#!/bin/bash

# Load config
source /scripts/toran-proxy/config.sh

# Initilisation
source $SCRIPTS_DIRECTORY/install/common.sh
source $SCRIPTS_DIRECTORY/install/toran.sh
source $SCRIPTS_DIRECTORY/install/ssh.sh
source $SCRIPTS_DIRECTORY/install/php.sh
source $SCRIPTS_DIRECTORY/install/nginx.sh
source $SCRIPTS_DIRECTORY/install/custom-scripts.sh

# Loading logs permissions
chown -R www-data:www-data \
    $DATA_DIRECTORY/logs \

# Start services
echo "Starting Toran Proxy..."
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
