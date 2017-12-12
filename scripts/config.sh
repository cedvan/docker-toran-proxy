#!/bin/bash

echo "Check environment configuration..."

# Directories
DATA_DIRECTORY=/data/toran-proxy
WORK_DIRECTORY=/var/www
ASSETS_DIRECTORY=/assets
SCRIPTS_DIRECTORY=/scripts/toran-proxy

# PHP Configuration
PHP_TIMEZONE=${PHP_TIMEZONE:-Europe/Paris}

# Toran Proxy Configuration
TORAN_HOST=${TORAN_HOST:-localhost}
TORAN_HTTP_PORT=${TORAN_HTTP_PORT:-80}
TORAN_HTTPS=${TORAN_HTTPS:-false}
TORAN_HTTPS_PORT=${TORAN_HTTPS_PORT:-443}
TORAN_REVERSE=${TORAN_REVERSE:-false}
TORAN_CRON_TIMER=${TORAN_CRON_TIMER:-fifteen}
TORAN_CRON_TIMER_DAILY_TIME=${TORAN_CRON_TIMER_DAILY_TIME:-04:00}
TORAN_TOKEN_GITHUB=${TORAN_TOKEN_GITHUB:-false}
TORAN_TRACK_DOWNLOADS=${TORAN_TRACK_DOWNLOADS:-false}
TORAN_MONO_REPO=${TORAN_MONO_REPO:-false}
TORAN_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
TORAN_AUTH_ENABLE=${TORAN_AUTH_ENABLE:-false}
TORAN_AUTH_USER=${TORAN_AUTH_USER:-toran}
TORAN_AUTH_PASSWORD=${TORAN_AUTH_PASSWORD:-toran}

# Checking PHP Timezone
if [[ ! "${PHP_TIMEZONE}" =~ ^[A-Z]{1}[a-z]+/[A-Z]{1}[a-z]+$ ]]; then
    echo "ERROR: "
    echo "  Variable PHP_TIMEZONE isn't valid ! (Format accepted : [A-Z]{1}[a-z]+/[A-Z]{1}[a-z]+)"
    exit 1
fi

# Checking Toran HTTPS Configuration and load Toran scheme
if [ "${TORAN_HTTPS}" = "true" ]; then
    [ -z "${TORAN_SCHEME}" ] && TORAN_SCHEME="https"
elif [ "${TORAN_HTTPS}" = "false" ]; then
    [ -z "${TORAN_SCHEME}" ] && TORAN_SCHEME="http"
else
    echo "ERROR: "
    echo "  Variable TORAN_HTTPS isn't valid ! (Values accepted : true/false)"
    exit 1
fi

# Checking HTTP PORT
if [[ ! ("${TORAN_HTTP_PORT}" =~ ^[1-9]{1}[0-9]{0,4}$) ]] || (("${TORAN_HTTP_PORT}" > "65535")); then
    echo "ERROR: "
    echo "  Variable TORAN_HTTP_PORT isn't valid ! (Format accepted : integer between 1 and 65535)"
    exit 1
fi

# Checking HTTPS PORT
if [[ ! ("${TORAN_HTTPS_PORT}" =~ ^[1-9]{1}[0-9]{0,4}$) ]] || (("${TORAN_HTTPS_PORT}" > "65535")); then
    echo "ERROR: "
    echo "  Variable TORAN_HTTP_PORT isn't valid ! (Format accepted : integer between 1 and 65535)"
    exit 1
fi

# Checking Toran reverse
if [ "${TORAN_REVERSE}" != "true" ] && [ "${TORAN_REVERSE}" != "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_REVERSE isn't valid ! (Values accepted : true/false)"
    exit 1
fi

# Checking Toran track reverse
if [ "${TORAN_TRACK_DOWNLOADS}" != "true" ] && [ "${TORAN_TRACK_DOWNLOADS}" != "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_TRACK_DOWNLOADS isn't valid ! (Values accepted : true/false)"
    exit 1
fi

# Checking Toran mono repo
if [ "${TORAN_MONO_REPO}" != "true" ] && [ "${TORAN_MONO_REPO}" != "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_MONO_REPO isn't valid ! (Values accepted : true/false)"
    exit 1
fi

# Checking Toran cron timer
if [ "${TORAN_CRON_TIMER}" != "minutes" ] && [ "${TORAN_CRON_TIMER}" != "five" ] && [ "${TORAN_CRON_TIMER}" != "fifteen" ] && [ "${TORAN_CRON_TIMER}" != "half" ] && [ "${TORAN_CRON_TIMER}" != "hour" ] && [ "${TORAN_CRON_TIMER}" != "daily" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_CRON_TIMER isn't valid ! (Values accepted : minutes/five/fifteen/half/hour)"
    exit 1
fi

# Checking Toran cron daily time
if [[ ! "${TORAN_CRON_TIMER_DAILY_TIME}" =~ ^[0-9]{2}:[0-9]{2}$ ]]; then
    echo "ERROR: "
    echo "  Variable TORAN_CRON_TIMER_DAILY_TIME isn't valid ! (Format accepted : HH:MM)"
    exit 1
fi

# Checking Toran Auth Enable
if [ "${TORAN_AUTH_ENABLE}" != "true" ] && [ "${TORAN_AUTH_ENABLE}" != "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_AUTH_ENABLE isn't valid ! (Values accepted : true/false)"
    exit 1
fi

# Checking Toran Auth User
if [ "${TORAN_AUTH_USER}" == "" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_AUTH_USER isn't valid! Must not be empty."
    exit 1
fi

# Checking Toran Auth Password
if [ "${TORAN_AUTH_PASSWORD}" == "" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_AUTH_PASSWORD isn't valid! Must not be empty."
    exit 1
fi
