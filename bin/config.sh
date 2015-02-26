#!/bin/bash

TORAN_PROXY_INIT=false

TORAN_PROXY_HTTPS=${TORAN_PROXY_HTTPS:-false}
TORAN_PROXY_HOST=${TORAN_PROXY_HOST:-false}
TORAN_PROXY_PACKAGIST=${TORAN_PROXY_PACKAGIST:-proxy}
TORAN_PROXY_SYNC=${TORAN_PROXY_SYNC:-lazy}
TORAN_PROXY_GIT_PREFIX=${TORAN_PROXY_GIT_PREFIX:-false}
TORAN_PROXY_GIT_PATH=${TORAN_PROXY_GIT_PATH:-false}

if [ "${TORAN_PROXY_HTTPS}" != "true" ] && [ "${TORAN_PROXY_HTTPS}" != "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_PROXY_HTTPS isn't valid ! (Values accepted : true/false)"
    exit 1
fi

if [ "${TORAN_PROXY_HOST}" == "false" ]; then
    echo "ERROR: "
    echo "  Please add a host for toran proxy in variable environnement (User -e TORAN_PROXY_HOST)"
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

if [ "${TORAN_PROXY_GIT_PREFIX}" != "false" ] && [ "${TORAN_PROXY_GIT_PATH}" == "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_PROXY_GIT_PATH is required if TORAN_PROXY_GIT_PREFIX is present !"
    exit 1
fi

if [ "${TORAN_PROXY_GIT_PREFIX}" == "false" ] && [ "${TORAN_PROXY_GIT_PATH}" = "false" ]; then
    echo "ERROR: "
    echo "  Variable TORAN_PROXY_GIT_PREFIX is required if TORAN_PROXY_GIT_PATH is present !"
    exit 1
fi