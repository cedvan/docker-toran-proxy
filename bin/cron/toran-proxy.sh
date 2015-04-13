#!/bin/bash

DATA_DIRECTORY=/data/toran-proxy
DATE="$(date)"

# Launch cron
echo "$DATE - Starting cron..." >> $DATA_DIRECTORY/logs/cron/cron.log
cd /var/www && php bin/cron -v >> $DATA_DIRECTORY/logs/cron/cron.log

# Refresh www-data permissions
chown -R www-data:www-data $DATA_DIRECTORY/mirrors $DATA_DIRECTORY/logs $DATA_DIRECTORY/toran