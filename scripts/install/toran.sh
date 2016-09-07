#!/bin/bash

echo "Configure Toran Proxy..."

# Load parameters toran
cp -f $WORK_DIRECTORY/app/config/parameters.yml.dist $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s|toran_scheme:.*|toran_scheme: $TORAN_SCHEME|g" $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s|toran_host:.*|toran_host: $TORAN_HOST|g" $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s|secret:.*|secret: $TORAN_SECRET|g" $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s|toran_http_port:.*|toran_http_port: $TORAN_HTTP_PORT|g" $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s|toran_https_port:.*|toran_https_port: $TORAN_HTTPS_PORT|g" $WORK_DIRECTORY/app/config/parameters.yml

# Load toran data
if [ ! -d $DATA_DIRECTORY/toran ]; then
    cp -rf $WORK_DIRECTORY/app/toran $DATA_DIRECTORY/toran
    cp -f $ASSETS_DIRECTORY/config/config.yml $DATA_DIRECTORY/toran/config.yml
fi
rm -rf $WORK_DIRECTORY/app/toran
ln -s $DATA_DIRECTORY/toran $WORK_DIRECTORY/app/toran

# Load config toran
sed -i "s|track_downloads:.*|track_downloads: $TORAN_TRACK_DOWNLOADS|g" $DATA_DIRECTORY/toran/config.yml
sed -i "s|monorepo:.*|monorepo: $TORAN_MONO_REPO|g" $DATA_DIRECTORY/toran/config.yml

# Load config composer
mkdir -p $DATA_DIRECTORY/toran/composer
if [ ! -e $DATA_DIRECTORY/toran/composer/auth.json ]; then
    if [ "${TORAN_TOKEN_GITHUB}" != "false" ]; then
        cp -f $ASSETS_DIRECTORY/config/composer.json $DATA_DIRECTORY/toran/composer/auth.json
        echo "Installing Token Github..."
        sed -i "s|\"github.com\":|\"github.com\":\"$TORAN_TOKEN_GITHUB\"|g" $DATA_DIRECTORY/toran/composer/auth.json
    else
        echo "WARNING: "
        echo "  Variable TORAN_TOKEN_GITHUB is empty !"
        echo "  You need to setup a GitHub OAuth token because Toran makes a lot of requests and will use up the API calls limit if it is unauthenticated"
        echo "  Head to https://github.com/settings/tokens/new to create a token. You need to select the public_repo credentials, and the repo one if you are going to use private repositories from GitHub with Toran."
    fi
else
  if [ "${TORAN_TOKEN_GITHUB}" != "false" ]; then
      echo "Updating Token Github..."
      sed -i "s|\"github.com\":.*|\"github.com\":\"$TORAN_TOKEN_GITHUB\"|g" $DATA_DIRECTORY/toran/composer/auth.json
  fi
fi

# Create packages directory
if [ ! -d $DATA_DIRECTORY/packagist ]; then
    echo "Creating packages directory..."
    mkdir -p $DATA_DIRECTORY/packagist
fi
if [ -d $WORK_DIRECTORY/web/repo/packagist/p ]; then
    rm -rf $WORK_DIRECTORY/web/repo/packagist/p
fi
mkdir -p $WORK_DIRECTORY/web/repo/packagist
ln -s $DATA_DIRECTORY/packagist $WORK_DIRECTORY/web/repo/packagist/p

# Create directory mirrors
if [ ! -d $DATA_DIRECTORY/mirrors ]; then
    echo "Creating mirrors directories..."
    mkdir -p $DATA_DIRECTORY/mirrors
fi
if [ -d $WORK_DIRECTORY/web/mirrors ]; then
    rm -rf $WORK_DIRECTORY/web/mirrors
fi
ln -s $DATA_DIRECTORY/mirrors $WORK_DIRECTORY/web/mirrors

# Installing Cron
echo "Installing Cron..."

# Loading Cron time
if [ "${TORAN_CRON_TIMER}" == "minutes" ]; then
    CRON_TIMER="* * * * *"
elif [ "${TORAN_CRON_TIMER}" == "five" ]; then
    CRON_TIMER="*/5 * * * *"
elif [ "${TORAN_CRON_TIMER}" == "fifteen" ]; then
    CRON_TIMER="*/15 * * * *"
elif [ "${TORAN_CRON_TIMER}" == "half" ]; then
    CRON_TIMER="*/30 * * * *"
elif [ "${TORAN_CRON_TIMER}" == "hour" ]; then
    CRON_TIMER="0 * * * *"
elif [ "${TORAN_CRON_TIMER}" == "daily" ]; then
    read CRON_TIMER_HOUR CRON_TIMER_MIN <<< ${TORAN_CRON_TIMER_DAILY_TIME//[:]/ }
    CRON_TIMER="$CRON_TIMER_MIN $CRON_TIMER_HOUR * * * *"
fi

echo "$CRON_TIMER root supervisorctl -u supervisor -p supervisor start toran-proxy-cron" >> /etc/cron.d/toran-proxy
echo "" >> /etc/cron.d/toran-proxy

# Load toran logs
mkdir -p $DATA_DIRECTORY/logs/toran
rm -f $WORK_DIRECTORY/app/logs/prod.log
ln -s $DATA_DIRECTORY/logs/toran/prod.log $WORK_DIRECTORY/app/logs/prod.log
ln -s $DATA_DIRECTORY/logs/toran/downloads.private.log $WORK_DIRECTORY/app/logs/downloads.private.log

# Loading permissions
echo "Loading permissions..."
chmod -R 777 $WORK_DIRECTORY/app/cache
chown -R www-data:www-data \
    $WORK_DIRECTORY \
    $DATA_DIRECTORY/toran \
    $DATA_DIRECTORY/mirrors
