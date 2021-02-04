FROM php:${VERSION}-cli

RUN apt-get -qq update && \
    apt-get -qqy install git libxml2-dev && \
    apt-get -qqy autoremove && \
    apt-get clean

RUN docker-php-ext-install soap
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install pdo_mysql
