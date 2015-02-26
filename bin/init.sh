#!/bin/bash

if [ -e $WORK_DIRECTORY/config.ini ]; then
    TORAN_INIT=true
else
    TORAN_INIT=false
fi

if [ "$TORAN_INIT" == "false" ]; then
    echo "Starting Initialisation..."
    source $BIN_DIRECTORY/install/toran.sh
    echo "TORAN_INIT=true" > $WORK_DIRECTORY/config.ini
fi

source $BIN_DIRECTORY/install/nginx.sh