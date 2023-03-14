FROM php:7.4-fpm

WORKDIR /var/www/html

RUN rm -rf public
RUN mkdir public

WORKDIR /var/www/html/public

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        git \
        zip \
        npm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd gettext mysqli pdo_mysql

# clone a repo to /var/www/html/public
# RUN git clone https://github.com/<EXAMPLE>.git .
# or copy your files to /var/www/html/public
# COPY ./config-example.php /var/www/html/public/config.php
COPY ./web/public/index.php /var/www/html/public/index.php

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# run composer install if you want to install dependencies
# RUN /usr/local/bin/composer install

RUN chown -R root /var/www/html

COPY ./etc/php/docker-php.ini /usr/local/etc/php/conf.d/99-overrides.ini

# run npm install if you want to install dependencies
# RUN npm install
# RUN npm run build && rm -r node_modules

RUN chown -R 33:33 /var/www/html \
    && chmod -R 775 /var/www/html
