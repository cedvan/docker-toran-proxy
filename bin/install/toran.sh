#!/bin/bash

echo "Installing Toran Proxy..."

# Toran Proxy Configuration
TORAN_HOST=${TORAN_HOST:-localhost}
TORAN_HTTPS=${TORAN_HTTPS:-false}
TORAN_PACKAGIST=${TORAN_PACKAGIST:-proxy}
TORAN_SYNC=${TORAN_SYNC:-lazy}
TORAN_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
TORAN_TOKEN_GITHUB=${TORAN_TOKEN_GITHUB:-""}


# Checking Toran Proxy Configuration
if [ "${TORAN_HTTPS}" != "true" ] && [ "${TORAN_HTTPS}" != "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_HTTPS isn't valid ! (Values accepted : true/false)"
    exit 1
fi

if [ "${TORAN_PACKAGIST}" != "proxy" ] && [ "${TORAN_PACKAGIST}" != "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_PACKAGIST isn't valid ! (Values accepted : proxy/false)"
    exit 1
fi

if [ "${TORAN_SYNC}" != "lazy" ] && [ "${TORAN_SYNC}" != "new" ] && [ "${TORAN_SYNC}" != "all" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_PACKAGIST isn't valid ! (Values accepted : lazy/new/all)"
    exit 1
fi


# Installing Toran Proxi
curl -sL https://toranproxy.com/releases/toran-proxy-v1.1.6.tgz | tar xzC /tmp
cp -rf /tmp/toran/* /var/www/
rm -rf /tmp/toran


# Installing Cron
echo "0 * * * * root php /var/www/bin/cron" >> /etc/crontab


# Loading Toran Proxy Configuration
cp -f $ASSETS_DIRECTORY/app/config/parameters.yml $WORK_DIRECTORY/app/config/parameters.yml
cp -f $ASSETS_DIRECTORY/app/toran/config.yml $WORK_DIRECTORY/app/toran/config.yml
mkdir $WORK_DIRECTORY/app/toran/composer && cp -f $ASSETS_DIRECTORY/app/toran/composer/auth.json $WORK_DIRECTORY/app/toran/composer/auth.json
sed -i "s/toran_scheme:/toran_scheme: $TORAN_HTTPS/g" $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s/toran_host:/toran_host: $TORAN_HOST/g" $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s/secret:/secret: $TORAN_SECRET/g" $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s/packagist_sync:/packagist_sync: $TORAN_PACKAGIST/g" $WORK_DIRECTORY/app/toran/config.yml
sed -i "s/dist_sync_mode:/dist_sync_mode: $TORAN_SYNC/g" $WORK_DIRECTORY/app/toran/config.yml
sed -i "s/\"github.com\":/\"github.com\": \"$TORAN_TOKEN_GITHUB\"/g" $WORK_DIRECTORY/app/toran/composer/auth.json

# Loading permissions
rm -rf $WORK_DIRECTORY/app/cache/*
rm -rf $WORK_DIRECTORY/app/logs/*
chmod -R 777 $WORK_DIRECTORY/app/cache $WORK_DIRECTORY/app/logs
mkdir $WORK_DIRECTORY/app/cache/prod
mkdir $WORK_DIRECTORY/app/logs/prod
chown -R www-data:www-data $WORK_DIRECTORY
