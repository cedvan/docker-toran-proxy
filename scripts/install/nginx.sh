#!/bin/bash

# Vhosts
echo "Loading Nginx vhosts..."
rm -f /etc/nginx/sites-enabled/*
if [ "${TORAN_HTTPS}" == "true" ]; then

    if [ "${TORAN_REVERSE}" == "false" ]; then

        echo "Loading HTTPS Certificates..."

        if [ ! -e "${DATA_DIRECTORY}/certs/toran-proxy.key" ] && [ ! -e "${DATA_DIRECTORY}/certs/toran-proxy.crt" ]; then

            echo "Generating self-signed HTTPS Certificates..."

            mkdir -p ${DATA_DIRECTORY}/certs

            openssl req \
                -x509 \
                -nodes \
                -days 365 \
                -newkey rsa:2048 \
                -keyout "${DATA_DIRECTORY}/certs/toran-proxy.key" \
                -out "${DATA_DIRECTORY}/certs/toran-proxy.crt" \
                -subj "/C=SS/ST=SS/L=SelfSignedCity/O=SelfSignedOrg/CN=${TORAN_HOST}"

        elif [ -e "${DATA_DIRECTORY}/certs/toran-proxy.key" ] && [ -e "${DATA_DIRECTORY}/certs/toran-proxy.crt" ]; then

            echo "Using provided HTTPS Certificates..."

        else

            if [ ! -e "${DATA_DIRECTORY}/certs/toran-proxy.key" ]; then
                echo "ERROR: "
                echo "  File toran-proxy.key exists in folder certs/ but no toran-proxy.crt"
                exit 1
            else
                echo "ERROR: "
                echo "  File toran-proxy.crt exists in folder certs/ but no toran-proxy.key"
                exit 1
            fi

        fi

        # Add certificates trusted
        ln -s $DATA_DIRECTORY/certs /usr/local/share/ca-certificates/toran-proxy
        update-ca-certificates

        ln -s /etc/nginx/sites-available/toran-proxy-https.conf /etc/nginx/sites-enabled/toran-proxy-https.conf

    else
        ln -s /etc/nginx/sites-available/toran-proxy-https-reverse.conf /etc/nginx/sites-enabled/toran-proxy-https-reverse.conf
    fi
else
    ln -s /etc/nginx/sites-available/toran-proxy-http.conf /etc/nginx/sites-enabled/toran-proxy-http.conf
fi

# Logs
mkdir -p $DATA_DIRECTORY/logs/nginx
