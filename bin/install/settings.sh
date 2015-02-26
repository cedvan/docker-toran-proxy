#!/bin/bash

# Packagist
sed -i "s/packagist_sync:/packagist_sync: $TORAN_PROXY_PACKAGIST/g" $WORK_DIRECTORY/app/toran/config.yml

# Sync
sed -i "s/dist_sync_mode:/dist_sync_mode: $TORAN_PROXY_SYNC/g" $WORK_DIRECTORY/app/toran/config.yml