FROM php:${VERSION}-cli

LABEL org.opencontainers.image.source https://github.com/luckyraul/php

RUN apt-get -qq update && \
    apt-get -qqy install git libxml2-dev && \
    curl -s -o /usr/local/bin/composer https://getcomposer.org/composer-1.phar && \
    chmod 0755 /usr/local/bin/composer && \
    apt-get -qqy autoremove && \
    apt-get clean

RUN docker-php-ext-install soap
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install pdo_mysql
