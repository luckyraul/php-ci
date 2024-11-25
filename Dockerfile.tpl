FROM php:${VERSION}-cli

ENV VAULT_VERSION 1.18.2

LABEL org.opencontainers.image.source https://github.com/luckyraul/php-ci

RUN apt-get -qq update && \
    apt-get -qqy install git openssh-client imagemagick && \
    apt-get -qqy install libxml2-dev libxslt-dev libpng-dev libjpeg-dev libzip-dev unzip libldap2-dev libc-client-dev libkrb5-dev libmagickwand-dev && \
    curl -s -o /usr/local/bin/composer https://getcomposer.org/download/latest-2.2.x/composer.phar && \
    chmod 0755 /usr/local/bin/composer && \
    composer global require symfony/console && \
    composer global require guzzlehttp/guzzle && \
    echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"' >> ~/.bashrc && \
    apt-get -qqy autoremove && \
    apt-get clean

RUN curl -O https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip vault_${VAULT_VERSION}_linux_amd64.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/vault && \
    rm -f vault_${VAULT_VERSION}_linux_amd64.zip

RUN docker-php-ext-install soap && \
    docker-php-ext-install bcmath && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install intl && \
    docker-php-ext-install xsl && \
    docker-php-ext-install pcntl && \
    docker-php-ext-install gd && \
    docker-php-ext-install ldap && \
    if [ "${VERSION}" != "8.4" ]; then docker-php-ext-configure imap --with-kerberos --with-imap-ssl; fi && \
    if [ "${VERSION}" != "8.4" ]; then docker-php-ext-install imap; fi && \
    docker-php-ext-install exif && \
    docker-php-ext-install zip && \
    docker-php-ext-install sockets && \
    pecl install imagick && \
    docker-php-ext-enable imagick

RUN echo "memory_limit=-1" >> /usr/local/etc/php/conf.d/memory_limit.ini
