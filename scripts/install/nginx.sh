#!/bin/bash

# Vhosts
echo "Loading Nginx vhosts..."
rm -f /etc/nginx/sites-enabled/*
if [ "${TORAN_HTTPS}" == "true" ]; then

    if [ "${TORAN_REVERSE}" == "false" ]; then

        echo "Loading HTTPS Certificates..."

        if [ ! -e "$DATA_DIRECTORY/certs/toran-proxy.key" ]; then
            echo "ERROR: "
            echo "  Please add toran-proxy.key in folder certs/"
            exit 1
        fi

        if [ ! -e "$DATA_DIRECTORY/certs/toran-proxy.crt" ]; then
            echo "ERROR: "
            echo "  Please add toran-proxy.crt in folder certs/"
            exit 1
        fi

        # Add certificates trusted
        ln -s $DATA_DIRECTORY/certs /usr/local/share/ca-certificates/toran-proxy
        update-ca-certificates

    fi

    if [ "${TORAN_REVERSE}" == "true" ]; then
        ln -s /etc/nginx/sites-available/toran-proxy-https-reverse.conf /etc/nginx/sites-enabled/toran-proxy-https-reverse.conf
    else
        ln -s /etc/nginx/sites-available/toran-proxy-https.conf /etc/nginx/sites-enabled/toran-proxy-https.conf
    fi
else

    if [ "${TORAN_REVERSE}" == "true" ]; then
        ln -s /etc/nginx/sites-available/toran-proxy-http-reverse.conf /etc/nginx/sites-enabled/toran-proxy-http-reverse.conf
    else
        ln -s /etc/nginx/sites-available/toran-proxy-http.conf /etc/nginx/sites-enabled/toran-proxy-http.conf
    fi
fi

# Logs
mkdir -p $DATA_DIRECTORY/logs/nginx

# Loading permissions
chown -R www-data:www-data \
    $DATA_DIRECTORY/logs \
