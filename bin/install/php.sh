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
TORAN_PHP_TIMEZONE=${TORAN_PHP_TIMEZONE/\//\\\/}
sed -i "s/;date\.timezone.*/date\.timezone = ${TORAN_PHP_TIMEZONE}/g" /etc/php5/fpm/php.ini
sed -i "s/;date\.timezone.*/date\.timezone = ${TORAN_PHP_TIMEZONE}/g" /etc/php5/cli/php.ini