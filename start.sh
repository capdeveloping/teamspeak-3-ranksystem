#!/bin/bash

if [ "$SUBPATH" = false ]; then
    export SUBFOLDER=""
fi

# Take action if $DIR exists. #
mkdir -p /var/www/html/$SUBFOLDER
mkdir -p /tmp/gitfolder
cd /tmp/gitfolder/
curl -s https://api.github.com/repos/Newcomer1989/TSN-Ranksystem/releases/latest | grep "zipball_url" | cut -d '"' -f 4 | wget -O ranksystem_latest.zip -i -
unzip ranksystem_latest.zip && rm ranksystem_latest.zip
find . -maxdepth 1 -mindepth 1 -type d -exec rsync -av --exclude dbconfig.php {}/ /var/www/html/$SUBFOLDER \;
rm -rf /tmp/gitfolder/

chown -R www-data:www-data /var/www/html/$SUBFOLDER
chmod -R ugo=rwx /var/www/html/$SUBFOLDER/update
chmod -R ugo=rwx /var/www/html/$SUBFOLDER/logs
chmod -R ugo=rwx /var/www/html/$SUBFOLDER/tsicons
chmod -R ugo=rwx /var/www/html/$SUBFOLDER/avatars
chmod ugo=rwx /var/www/html/$SUBFOLDER/other/dbconfig.php


if [[ "$SUBPATH" && ! -z "$SUBFOLDER" ]]; then
    echo "$CRONTIMES root /usr/local/bin/php /var/www/html/$SUBFOLDER/worker.php check >/dev/null 2>&1" > /etc/cron.d/ts3-bot
else
    echo "$CRONTIMES root /usr/local/bin/php /var/www/html/worker.php check >/dev/null 2>&1" > /etc/cron.d/ts3-bot
fi

# Change the default root of apache
if ! "$SUBPATH" && ! grep -q "/var/www/html/$SUBFOLDER" /etc/apache2/sites-available/000-default.conf ; then
    sed -i ' s/\<var\/www\/html\>/&\/'$SUBFOLDER'/' /etc/apache2/sites-available/000-default.conf
fi

mkdir /var/www/html/ranksystem/logs/ -p
chmod 740 /var/www/html/ranksystem/logs/
chown -R www-data:www-data /var/www/html/ranksystem/logs/

/usr/local/bin/php /var/www/html/$SUBFOLDER/worker.php check

service cron stop
service cron start

apache2-foreground
