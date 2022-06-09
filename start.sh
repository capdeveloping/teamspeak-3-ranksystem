#!/bin/bash

if [ "$SUBPATH" = false ]; then
    export SUBFOLDER=""
fi

# Take action if $DIR exists. #
mkdir -p /tmp/gitfolder
mkdir -p /var/www/html/$SUBFOLDER
cd /tmp/gitfolder/
wget https://ts-n.net/downloads/ranksystem_latest.zip
unzip ranksystem_latest.zip && rm ranksystem_latest.zip
rsync -av --exclude dbconfig.php . /var/www/html/$SUBFOLDER
rm -rf /tmp/gitfolder/

chown -R www-data:www-data /var/www/html/$SUBFOLDER
chmod -R ugo=rwx /var/www/html/$SUBFOLDER/update
chmod -R ugo=rwx /var/www/html/$SUBFOLDER/logs
chmod -R ugo=rwx /var/www/html/$SUBFOLDER/tsicons
chmod -R ugo=rwx /var/www/html/$SUBFOLDER/avatars
chmod ugo=rwx /var/www/html/$SUBFOLDER/other/dbconfig.php


if [[ "$SUBPATH" && ! -z "$SUBFOLDER" ]]; then
    echo "$CRONTIMES www-data php /var/www/html/$SUBFOLDER/worker.php check >/dev/null 2>&1" > /etc/cron.d/ts3-bot
else
    echo "$CRONTIMES www-data php /var/www/html/worker.php check >/dev/null 2>&1" > /etc/cron.d/ts3-bot
fi

# Change the default root of apache
if ! "$SUBPATH" && ! grep -q "/var/www/html/$SUBFOLDER" /etc/apache2/sites-available/000-default.conf ; then
    sed -i ' s/\<var\/www\/html\>/&\/'$SUBFOLDER'/' /etc/apache2/sites-available/000-default.conf
fi

mkdir /var/www/html/ranksystem/logs/ -p
chmod 740 /var/www/html/ranksystem/logs/
chown -R www-data:www-data /var/www/html/ranksystem/logs/

service cron stop
service cron start

apache2-foreground
