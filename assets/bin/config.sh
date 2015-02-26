#!/bin/bash

TORAN_PROXY_HTTPS=${TORAN_PROXY_HTTPS:-false}
TORAN_PROXY_HOST=${TORAN_PROXY_HOST:-false}

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