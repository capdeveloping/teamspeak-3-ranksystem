#!/bin/bash

if [ ! -d "/var/www/html/$SUBFOLDER" ]; then
    # Take action if $DIR exists. #
    mkdir -p /var/www/html/$SUBFOLDER
    cd /var/www/html/$SUBFOLDER
    git clone https://github.com/Newcomer1989/TSN-Ranksystem.git .
    chown -R www-data:www-data /var/www/html/$SUBFOLDER
    chmod -R ugo=rwx /var/www/html/$SUBFOLDER/update
    chmod -R ugo=rwx /var/www/html/$SUBFOLDER/logs
    chmod -R ugo=rwx /var/www/html/$SUBFOLDER/tsicons
    chmod -R ugo=rwx /var/www/html/$SUBFOLDER/avatars
    chmod ugo=rwx /var/www/html/$SUBFOLDER/other/dbconfig.php

    # Change the default root of apache
    if [ "$SUBPATH" = "false" ] ; then
        sed -i ' s/\<var\/www\/html\>/&\/'$SUBFOLDER'/' /etc/apache2/sites-available/000-default.conf
    fi
fi

apache2-foreground
