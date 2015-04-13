#!/bin/bash

echo "Configure Toran Proxy..."

# Toran Proxy Configuration
TORAN_HOST=${TORAN_HOST:-localhost}
TORAN_HTTPS=${TORAN_HTTPS:-false}
TORAN_CRON=${TORAN_CRON:-true}
TORAN_TOKEN_GITHUB=${TORAN_TOKEN_GITHUB:-}
TORAN_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Checking Toran Proxy Configuration
if [ "${TORAN_HTTPS}" != "true" ] && [ "${TORAN_HTTPS}" != "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_HTTPS isn't valid ! (Values accepted : true/false)"
    exit 1
fi

# Load parameters toran
cp -f $WORK_DIRECTORY/app/config/parameters.yml.dist $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s/toran_scheme:/toran_scheme: $TORAN_HTTPS/g" $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s/toran_host:/toran_host: $TORAN_HOST/g" $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s/secret:/secret: $TORAN_SECRET/g" $WORK_DIRECTORY/app/config/parameters.yml

# Load toran data
if [ ! -d $DATA_DIRECTORY/toran ]; then
    cp -rf $WORK_DIRECTORY/app/toran $DATA_DIRECTORY/toran
fi
rm -rf $WORK_DIRECTORY/app/toran
ln -s $DATA_DIRECTORY/toran $WORK_DIRECTORY/app/toran

# Load config toran
if [ ! -e $DATA_DIRECTORY/toran/config.yml ]; then
    cp -f $ASSETS_DIRECTORY/config/config.yml $DATA_DIRECTORY/toran/config.yml
fi

# Load config composer
if [ -e $DATA_DIRECTORY/toran/composer/auth.json ]; then
    rm -rf $DATA_DIRECTORY/toran/composer/auth.json
fi
mkdir -p $DATA_DIRECTORY/toran/composer
cp -f $ASSETS_DIRECTORY/config/composer.json $DATA_DIRECTORY/toran/composer/auth.json
sed -i "s/\"github.com\":/\"github.com\":\"$TORAN_TOKEN_GITHUB\"/g" $WORK_DIRECTORY/app/toran/composer/auth.json

# Create directory mirrors
if [ ! -e $DATA_DIRECTORY/mirrors ]; then
    mkdir -p $DATA_DIRECTORY/mirrors
fi
ln -s $DATA_DIRECTORY/mirrors $WORK_DIRECTORY/web/mirrors

# Create directories logs
if [ ! -d "$DATA_DIRECTORY/logs" ]; then
    echo "Creating logs directories..."
    mkdir -p $DATA_DIRECTORY/logs/nginx
    mkdir -p $DATA_DIRECTORY/logs/cron
    chmod -R 644 $DATA_DIRECTORY/logs
    chown -R www-data:www-data $DATA_DIRECTORY/logs
fi

# Installing Cron
if [ "${TORAN_CRON}" == true ]; then
    echo "Installing Cron..."
    echo "* * * * * root /bin/bash $BIN_DIRECTORY/cron/toran-proxy.sh" >> /etc/cron.d/toran-proxy
    echo "" >> /etc/cron.d/toran-proxy
fi

# Loading permissions
chmod -R 777 $WORK_DIRECTORY/app/cache
chown -R www-data:www-data \
    $WORK_DIRECTORY \
    $DATA_DIRECTORY/toran \
    $DATA_DIRECTORY/mirrors
