#!/bin/bash

echo "Configure Toran Proxy..."

# Toran Proxy Configuration
TORAN_HOST=${TORAN_HOST:-localhost}
TORAN_HTTPS=${TORAN_HTTPS:-false}
TORAN_CRON_TIMER=${TORAN_CRON_TIMER:-minutes}
TORAN_CRON_TIMER_DAILY_TIME=${TORAN_CRON_TIMER_DAILY_TIME:-04:00}
TORAN_TOKEN_GITHUB=${TORAN_TOKEN_GITHUB:-false}
TORAN_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# Checking Toran Proxy Configuration
if [ "${TORAN_HTTPS}" != "true" ] && [ "${TORAN_HTTPS}" != "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_HTTPS isn't valid ! (Values accepted : true/false)"
    exit 1
fi

# Checking Cron time
if [ "${TORAN_CRON_TIMER}" != "minutes" ] && [ "${TORAN_CRON_TIMER}" != "five" ] && [ "${TORAN_CRON_TIMER}" != "fifteen" ] && [ "${TORAN_CRON_TIMER}" != "half" ] && [ "${TORAN_CRON_TIMER}" != "hour" ] && [ "${TORAN_CRON_TIMER}" != "daily" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_CRON_TIMER isn't valid ! (Values accepted : minutes/five/fifteen/half/hour)"
    exit 1
fi

# Checking Cron daily time
if [[ ! "${TORAN_CRON_TIMER_DAILY_TIME}" =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
    echo "ERROR: "
    echo "  Variable TORAN_CRON_TIMER_DAILY_TIME isn't valid ! (Format accepted : HH:MM)"
    exit 1
fi

# Load parameters toran
cp -f $WORK_DIRECTORY/app/config/parameters.yml.dist $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s/toran_scheme:.*/toran_scheme: $TORAN_HTTPS/g" $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s/toran_host:.*/toran_host: $TORAN_HOST/g" $WORK_DIRECTORY/app/config/parameters.yml
sed -i "s/secret:.*/secret: $TORAN_SECRET/g" $WORK_DIRECTORY/app/config/parameters.yml

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
# Workaround for Toran bug (hardcoded config path)
ln -sf $DATA_DIRECTORY/toran/config.yml $WORK_DIRECTORY/app/config/toran.yml

# Load config composer
mkdir -p $DATA_DIRECTORY/toran/composer
if [ "${TORAN_TOKEN_GITHUB}" != "false" ]; then
    echo "Installing Token Github..."
    if [ -e $DATA_DIRECTORY/toran/composer/auth.json ]; then
        rm -rf $DATA_DIRECTORY/toran/composer/auth.json
    fi
    cp -f $ASSETS_DIRECTORY/config/composer.json $DATA_DIRECTORY/toran/composer/auth.json
    sed -i "s/\"github.com\":/\"github.com\":\"$TORAN_TOKEN_GITHUB\"/g" $WORK_DIRECTORY/app/toran/composer/auth.json
else
     echo "Warning Token Github is empty ! Banishment from github possible, cron job will be disrupted"
fi

# Create directory mirrors
if [ ! -d $DATA_DIRECTORY/mirrors ]; then
    echo "Creating mirrors directories..."
    mkdir -p $DATA_DIRECTORY/mirrors
fi
if [ -d $WORK_DIRECTORY/web/mirrors ]; then
    rm -rf $WORK_DIRECTORY/web/mirrors
fi
ln -s $DATA_DIRECTORY/mirrors $WORK_DIRECTORY/web/mirrors

# Create logs nginx directories
if [ ! -d "/var/log/toran-proxy/nginx" ]; then
    echo "Creating logs directories for nginx..."
    mkdir -p /var/log/toran-proxy/nginx
fi

# Create logs cron directories
if [ ! -d "/var/log/toran-proxy/cron" ]; then
    echo "Creating logs directories for cron..."
    mkdir -p /var/log/toran-proxy/cron
fi

# Create logs symbolic links
if [ -d $DATA_DIRECTORY/logs ]; then
    rm -rf $DATA_DIRECTORY/logs
fi
ln -s /var/log/toran-proxy $DATA_DIRECTORY/logs
if [ -d /logs ]; then
    rm -rf /logs
fi
ln -s /var/log/toran-proxy /logs

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
    CRON_TIMER="*/1 * * * *"
elif [ "${TORAN_CRON_TIMER}" == "daily" ]; then
    read CRON_TIMER_HOUR CRON_TIMER_MIN <<< ${TORAN_CRON_TIMER_DAILY_TIME//[:]/ }
    CRON_TIMER="$CRON_TIMER_MIN $CRON_TIMER_HOUR * * * *"
fi

echo "$CRON_TIMER root /bin/bash $BIN_DIRECTORY/cron/toran-proxy.sh" >> /etc/cron.d/toran-proxy
echo "" >> /etc/cron.d/toran-proxy

# Loading permissions
echo "Loading permissions..."
chmod -R 644 /var/log/toran-proxy
chmod -R 777 $WORK_DIRECTORY/app/cache
chown -R www-data:www-data \
    $WORK_DIRECTORY \
    $DATA_DIRECTORY/toran \
    $DATA_DIRECTORY/mirrors \
    /var/log/toran-proxy
