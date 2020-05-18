FROM php:7.4.3-apache

ENV SUBPATH=true
ENV SUBFOLDER=ranksystem

EXPOSE 80/tcp

RUN apt-get update -y \
    && apt upgrade -y \
    && apt-get install -y libcurl3-dev libzip-dev libssh2-1-dev libonig-dev git rsync \
    && pecl install ssh2-1.2 \
    && docker-php-ext-install curl \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mbstring \
    && docker-php-ext-enable curl \
    && docker-php-ext-enable zip \
    && docker-php-ext-enable pdo \
    && docker-php-ext-enable pdo_mysql \
    && docker-php-ext-enable ssh2 \
    && docker-php-ext-enable mbstring

COPY start.sh /etc/start.sh

RUN chmod +x /etc/start.sh

CMD ["bash", "/etc/start.sh"]
