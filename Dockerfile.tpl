FROM php:${VERSION}-cli

ENV VAULT_VERSION 1.9.0
ENV WAYPOINT_VERSION 0.6.2

LABEL org.opencontainers.image.source https://github.com/luckyraul/php-ci

RUN apt-get -qq update && \
    apt-get -qqy install git openssh-client && \
    apt-get -qqy install libxml2-dev libxslt-dev libpng-dev libjpeg-dev libzip-dev unzip libldap2-dev libc-client-dev libkrb5-dev && \
    curl -s -o /usr/local/bin/composer https://getcomposer.org/composer-1.phar && \
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

RUN curl -O https://releases.hashicorp.com/waypoint/${WAYPOINT_VERSION}/waypoint_${WAYPOINT_VERSION}_linux_amd64.zip && \
    unzip waypoint_${WAYPOINT_VERSION}_linux_amd64.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/waypoint && \
    rm -f waypoint_${WAYPOINT_VERSION}_linux_amd64.zip

RUN docker-php-ext-install soap && \
    docker-php-ext-install bcmath && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install intl && \
    docker-php-ext-install xsl && \
    docker-php-ext-install pcntl && \
    docker-php-ext-install gd && \
    docker-php-ext-install ldap && \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap && \
    docker-php-ext-install exif && \
    docker-php-ext-install zip && \
    docker-php-ext-install sockets

RUN echo "memory_limit=-1" >> /usr/local/etc/php/conf.d/memory_limit.ini
