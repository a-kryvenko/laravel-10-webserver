FROM php:8.1-fpm

ARG GID
ARG UID

USER root

WORKDIR /var/webserver

RUN apt-get update -y \
    && apt-get autoremove -y \
    && apt-get install -y --no-install-recommends \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libbz2-dev \
    libssl-dev \
    libicu-dev \
    zip \
    unzip \
    curl \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install gd exif mbstring mysqli pdo pdo_mysql \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN getent group www || groupadd -g $GID www \
    && getent passwd $UID || useradd -u $UID -m -s /bin/bash -g www www

USER www

EXPOSE 9000

CMD ["php-fpm"]
