#!/bin/bash

# Installing ssh keys
if [ -e "$DATA_DIRECTORY/ssh" ]; then

    echo "Installing ssh config..."

    mkdir /root/.ssh

    if [ -e "$DATA_DIRECTORY/ssh/id_rsa" ]; then
        chmod 600 $DATA_DIRECTORY/ssh/id_rsa
        ln -s $DATA_DIRECTORY/ssh/id_rsa /root/.ssh/id_rsa
    fi

    if [ -e "$DATA_DIRECTORY/ssh/id_rsa.pub" ]; then
        chmod 644 $DATA_DIRECTORY/ssh/id_rsa.pub
        ln -s $DATA_DIRECTORY/ssh/id_rsa.pub /root/.ssh/id_rsa.pub
    fi

    if [ -e "$DATA_DIRECTORY/ssh/known_hosts" ]; then
        chmod 644 $DATA_DIRECTORY/ssh/known_hosts
        ln -s $DATA_DIRECTORY/ssh/known_hosts /root/.ssh/known_hosts
    fi

fi
