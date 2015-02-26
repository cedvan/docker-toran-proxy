#!/bin/bash

TORAN_PROXY_INIT=false

TORAN_PROXY_HOST=${TORAN_PROXY_HOST:-localhost}
TORAN_PROXY_HTTPS=${TORAN_PROXY_HTTPS:-false}
TORAN_PROXY_PACKAGIST=${TORAN_PROXY_PACKAGIST:-proxy}
TORAN_PROXY_SYNC=${TORAN_PROXY_SYNC:-lazy}

if [ "${TORAN_PROXY_HTTPS}" != "true" ] && [ "${TORAN_PROXY_HTTPS}" != "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_PROXY_HTTPS isn't valid ! (Values accepted : true/false)"
    exit 1
fi

if [ "${TORAN_PROXY_PACKAGIST}" != "proxy" ] && [ "${TORAN_PROXY_PACKAGIST}" != "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_PROXY_PACKAGIST isn't valid ! (Values accepted : proxy/false)"
    exit 1
fi

if [ "${TORAN_PROXY_SYNC}" != "lazy" ] && [ "${TORAN_PROXY_SYNC}" != "new" ] && [ "${TORAN_PROXY_SYNC}" != "all" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_PROXY_PACKAGIST isn't valid ! (Values accepted : lazy/new/all)"
    exit 1
fi