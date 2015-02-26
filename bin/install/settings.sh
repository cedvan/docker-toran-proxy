#!/bin/bash

if [ -e $DATA_DIRECTORY/config/settings.yml ]; then

    rm -f $WORK_DIRECTORY/app/toran/config.yml
    cp -f $DATA_DIRECTORY/config/settings.yml $WORK_DIRECTORY/app/toran/config.yml

else

    # Packagist
    sed -i "s/packagist_sync:/packagist_sync: $TORAN_PROXY_PACKAGIST/g" $WORK_DIRECTORY/app/toran/config.yml

    # Sync
    sed -i "s/dist_sync_mode:/dist_sync_mode: $TORAN_PROXY_SYNC/g" $WORK_DIRECTORY/app/toran/config.yml

    cp -f $WORK_DIRECTORY/app/toran/config.yml $DATA_DIRECTORY/config/settings.yml

fi
