#!/bin/bash

# Scheme
sed -i "s/toran_scheme:/toran_scheme: $TORAN_PROXY_HTTPS/g" $WORK_DIRECTORY/app/config/parameters.yml

# Host
sed -i "s/toran_host:/toran_host: $TORAN_PROXY_HOST/g" $WORK_DIRECTORY/app/config/parameters.yml

# Secret
SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
sed -i "s/secret:/secret: $SECRET/g" $WORK_DIRECTORY/app/config/parameters.yml