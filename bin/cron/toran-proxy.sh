#!/bin/bash

DATA_DIRECTORY=/data/toran-proxy
LOGS_DIRECTORY=/var/log/toran-proxy
DATE="$(date)"

# Launch cron
echo "$DATE - Starting cron..." >> $LOGS_DIRECTORY/cron/cron.log
cd /var/www && php bin/cron -v >> $LOGS_DIRECTORY/cron/cron.log 2>&1

# Refresh www-data permissions
chown -R www-data:www-data $DATA_DIRECTORY/mirrors $DATA_DIRECTORY/toran
