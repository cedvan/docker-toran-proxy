#!/bin/bash

# Basic Auth
echo "Detecting HTTP Basic Authentication Configuration"
if [ "${TORAN_AUTH_ENABLE}" != "false" ]; then

    if [ ! -e /etc/nginx/.htpasswd ]; then

        echo "Generating .htpasswd file"

        htpasswd -bc /etc/nginx/.htpasswd ${TORAN_AUTH_USER} ${TORAN_AUTH_PASSWORD}

    else

        echo "Skipping .htpasswd generation - already exists."

    fi

    echo "Configuring Nginx for HTTP Basic Authentication..."
    sed -i "s|# auth_basic|auth_basic|g" /etc/nginx/sites-available/toran-proxy-http.conf
    sed -i "s|# auth_basic|auth_basic|g" /etc/nginx/sites-available/toran-proxy-https-reverse.conf
    sed -i "s|# auth_basic|auth_basic|g" /etc/nginx/sites-available/toran-proxy-https.conf

fi

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

        sed -i "s|TORAN_HTTP_PORT|$TORAN_HTTP_PORT|g" /etc/nginx/sites-available/toran-proxy-https.conf
        sed -i "s|TORAN_HTTPS_PORT|$TORAN_HTTPS_PORT|g" /etc/nginx/sites-available/toran-proxy-https.conf
        ln -s /etc/nginx/sites-available/toran-proxy-https.conf /etc/nginx/sites-enabled/toran-proxy-https.conf

    else

        sed -i "s|TORAN_HTTP_PORT|$TORAN_HTTP_PORT|g" /etc/nginx/sites-available/toran-proxy-https-reverse.conf
        sed -i "s|TORAN_HTTPS_PORT|$TORAN_HTTPS_PORT|g" /etc/nginx/sites-available/toran-proxy-https-reverse.conf
        ln -s /etc/nginx/sites-available/toran-proxy-https-reverse.conf /etc/nginx/sites-enabled/toran-proxy-https-reverse.conf
    fi
else
    sed -i "s|TORAN_HTTP_PORT|$TORAN_HTTP_PORT|g" /etc/nginx/sites-available/toran-proxy-http.conf
    ln -s /etc/nginx/sites-available/toran-proxy-http.conf /etc/nginx/sites-enabled/toran-proxy-http.conf
fi

# Logs
mkdir -p $DATA_DIRECTORY/logs/nginx
