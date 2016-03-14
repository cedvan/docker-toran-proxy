#!/bin/bash

echo "Configure PHP..."

# PHP Configuration
TORAN_PHP_TIMEZONE=${TORAN_PHP_TIMEZONE:-Europe/Paris}

# Checking PHP Timezone
if [[ ! "${TORAN_PHP_TIMEZONE}" =~ ^[A-Z]{1}[a-z]+/[A-Z]{1}[a-z]+$ ]]; then
    echo "ERROR: "
    echo "  Variable TORAN_PHP_TIMEZONE isn't valid ! (Format accepted : [A-Z]{1}[a-z]+/[A-Z]{1}[a-z]+)"
    exit 1
fi

# Config PHP Timezone
sed -i "s|;date.timezone =.*|date.timezone = ${TORAN_PHP_TIMEZONE}|g" /etc/php5/fpm/php.ini
sed -i "s|;date.timezone =.*|date.timezone = ${TORAN_PHP_TIMEZONE}|g" /etc/php5/cli/php.ini

# Logs
mkdir -p $DATA_DIRECTORY/logs/php-fpm
mkdir -p $DATA_DIRECTORY/logs/php-cli
sed -i "s|;error_log = php_errors.log|error_log = ${DATA_DIRECTORY}/logs/php-fpm/errors.log|g" /etc/php5/fpm/php.ini
sed -i "s|;error_log = php_errors.log|error_log = ${DATA_DIRECTORY}/logs/php-cli/errors.log|g" /etc/php5/cli/php.ini
