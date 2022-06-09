# docker-teamspeak-ranksystem
image for https://ts-n.net/ranksystem.php

# important

A note to all who want to use this repo:
I am a beginner. Most of what i wrote happened by "trial and error". Please be aware of that.

# docker-compose exmaple

---

services:
  mysql:
    container_name: mysql
    restart: always
    image: mysql:latest
    cap_add: [ SYS_NICE ]
    volumes:
      - /path/fo/folder/mysql:/var/lib/mysql
    environment:
        MYSQL_ROOT_PASSWORD: password
        MYSQL_USER: ts3ranksystem
        MYSQL_PASSWORD: ts3rankpassword

  ranksystem:
    image: capdeveloping/teamspeak-3-ranksystem:latest
    container_name: teamspeak_ranksystem
    restart: always
    environment:
      SUBPATH: true (optional - default value)
      SUBFOLDER: "ranksystem" (optional - default value)
      CRONTIMES: "*/10 * * * *" (optional - default value)
    ports:
      - 8088:80
    volumes:
      - /path/to/folder/ranksystem/dbconfig.php:/var/www/html/other/dbconfig.php
