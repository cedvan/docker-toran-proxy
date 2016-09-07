#!/bin/bash

# Create logs directory
if [ -d $DATA_DIRECTORY/logs ]; then
    rm -rf $DATA_DIRECTORY/logs
fi
mkdir $DATA_DIRECTORY/logs
