FROM php:8.1-fpm

# environment arguments
ARG UID
ARG GID
ARG USER

ENV UID=${UID}
ENV GID=${GID}
ENV USER=${USER}

USER root

# Creating user and group
RUN getent group www || groupadd -g $GID www \
    && getent passwd $UID || useradd -u $UID -m -s /bin/bash -g www www

# Modify php fpm configuration to use the new user's priviledges.
RUN sed -i "s/user = www-data/user = 'www'/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = 'www'/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

# Installing php extensions
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

# Installing redis extension
RUN mkdir -p /usr/src/php/ext/redis \
    && curl -fsSL https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

# Configure connection to mail sender container
COPY --chown=www:www .msmtprc /etc/msmtprc.default
COPY --chown=www:www .msmtprc /etc/msmtprc

USER www

# When runned - set msmtp configuration and up php-fpm
CMD cp /etc/msmtprc.default /tmp/msmtprc \
    && sed -i "s/#EMAIL#/$SMTP_EMAIL/" /tmp/msmtprc \
    && sed -i "s/#CONTAINER#/$SMTP_CONTAINER/" /tmp/msmtprc \
    && cat /tmp/msmtprc >/etc/msmtprc \
    && rm /tmp/msmtprc \
    && php-fpm -y /usr/local/etc/php-fpm.conf -R
