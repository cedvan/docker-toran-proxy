#!/bin/bash

# Installing ssh keys
if [ -e "$DATA_DIRECTORY/ssh" ]; then

    echo "Installing ssh config..."

    mkdir /var/www/.ssh

    if [ -e "$DATA_DIRECTORY/ssh/id_rsa" ]; then
        chgrp 545 $DATA_DIRECTORY/ssh/id_rsa
        chmod 600 $DATA_DIRECTORY/ssh/id_rsa
        ln -s $DATA_DIRECTORY/ssh/id_rsa /var/www/.ssh/id_rsa
    fi

    if [ -e "$DATA_DIRECTORY/ssh/id_rsa.pub" ]; then
        chmod 644 $DATA_DIRECTORY/ssh/id_rsa.pub
        ln -s $DATA_DIRECTORY/ssh/id_rsa.pub /var/www/.ssh/id_rsa.pub
    fi

    if [ -e "$DATA_DIRECTORY/ssh/known_hosts" ]; then
        chmod 644 $DATA_DIRECTORY/ssh/known_hosts
        ln -s $DATA_DIRECTORY/ssh/known_hosts /var/www/.ssh/known_hosts
    fi

    if [ -e "$DATA_DIRECTORY/ssh/config" ]; then
        chmod 644 $DATA_DIRECTORY/ssh/config
        ln -s $DATA_DIRECTORY/ssh/config /var/www/.ssh/config
    fi

    chmod 700 $DATA_DIRECTORY/ssh
    chown -R www-data:www-data $DATA_DIRECTORY/ssh

fi
