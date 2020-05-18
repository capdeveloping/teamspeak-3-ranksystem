#!/bin/bash

# Take action if $DIR exists. #
mkdir -p /tmp/gitfolder
mkdir -p /var/www/html/$SUBFOLDER
cd /tmp/gitfolder/
git clone https://github.com/Newcomer1989/TSN-Ranksystem.git .
rsync -av --exclude dbconfig.php . /var/www/html/$SUBFOLDER
rm -rf /tmp/gitfolder/

chown -R www-data:www-data /var/www/html/$SUBFOLDER
chmod -R ugo=rwx /var/www/html/$SUBFOLDER/update
chmod -R ugo=rwx /var/www/html/$SUBFOLDER/logs
chmod -R ugo=rwx /var/www/html/$SUBFOLDER/tsicons
chmod -R ugo=rwx /var/www/html/$SUBFOLDER/avatars
chmod ugo=rwx /var/www/html/$SUBFOLDER/other/dbconfig.php
# Change the default root of apache
if ! "$SUBPATH" && ! grep -q "/var/www/html/$SUBFOLDER" /etc/apache2/sites-available/000-default.conf ; then
    sed -i ' s/\<var\/www\/html\>/&\/'$SUBFOLDER'/' /etc/apache2/sites-available/000-default.conf
fi

mkdir /var/www/html/ranksystem/logs/ -p
chmod 740 /var/www/html/ranksystem/logs/
chown -R www-data:www-data /var/www/html/ranksystem/logs/

apache2-foreground
