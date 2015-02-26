#!/bin/bash

WORK_DIRECTORY=/var/www
BIN_DIRECTORY=/bin/toran-proxy

# Configuration
source $BIN_DIRECTORY/config.sh

# Initilisation
source $BIN_DIRECTORY/init.sh
if [ "$TORAN_PROXY_INIT" == "false" ]; then
    source $BIN_DIRECTORY/nginx.sh
    source $BIN_DIRECTORY/build.sh
    sed -i "s/TORAN_PROXY_INIT=false/TORAN_PROXY_INIT=true/g" $BIN_DIRECTORY/init.sh
fi