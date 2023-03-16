# Webserver on docker containers for Laravel 10.0

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://stand-with-ukraine.pp.ua)

Based on **[docker-webserver](https://github.com/a-kryvenko/docker-webserver)**.

Webserver included:
- Nginx
- PHP
- Redis
- MySQL
- composer
- cloud backups
- Mailhog (for development environment)
- NodeJS (for development environment)

## Before starting

1. **[Prepare](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-22-04)** server;
2. **[Install](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)** **docker**;
3. **[Install](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04)** **docker-compose**;
4. Optional. For production server configure **[acme-companion](https://github.com/nginx-proxy/acme-companion)** - nginx-proxy an certificates.

## Installation:

### 1. Clone repository

~~~
git clone git@github.com:a-kryvenko/laravel-10-webserver.git .
~~~

### 2. Create copy of .env file:

~~~
cp .env.example .env
~~~

### 3. Modify .env, set up variables

- <b>COMPOSE_SEPARATOR</b> - separator for compose files in .env file. "<b>:</b>" for linux/MacOS, "<b>;</b>" for Windows;
- <b>COMPOSE_FILE</b> - which docker-compose files will be included;
- <b>SYSTEM_GROUP_ID</b> - ID of host user group. Usually 1000;
- <b>SYSTEM_USER_ID</b> - ID of host user. Usually 1000;
- <b>APP_NAME</b> - <b>url</b> by which the site is accessible. For example, <b>example.com</b> or <b>example.local</b> for local development;
- <b>ADMINISTRATOR_EMAIL</b> - email to which we send information about certificates;
- <b>DB_HOST</b> - database host. By default <b>db</b>, but in the case when the database is on another server - specify the server address;
- <b>DB_DATABASE</b> - database name;
- <b>DB_USER</b> - the name of the user who works with the database;
- <b>DB_USER_PASSWORD</b> - database user password;
- <b>DB_ROOT_PASSWORD</b> - password of the <b>root</b> database user;
- <b>AWS_S3_URL</b> - <b>url</b> of cloud backup storage;
- <b>AWS_S3_BUCKET</b> - name of the bucket in the backup storage;
- <b>AWS_S3_ACCESS_KEY_ID</b> - storage key;
- <b>AWS_S3_SECRET_ACCESS_KEY</b> - storage password;
- <b>AWS_S3_LOCAL_MOUNT_POINT</b> - path to the local folder where we mount the cloud storage.

### 4. Compose files description

- <b>dc-app.yml</b> - core webserver services. Include nginx, php, redis;
- <b>dc-db.yml</b> - database service. Use if you database is on same server;
- <b>dc-dev.yml</b> - dev environment services. NPM, NodeJs, MailHog;
- <b>dc-cloud.yml</b> - cloud backups storage.

### 5. Create folder for website content

~~~ 
mkdir www
~~~

### 6. Build images and up server

~~~
docker-compose build \  
docker-compose up -d
~~~

### 7. Initialize crontab

~~~ 
./cgi-bin/prepare-crontab.sh
~~~

### 8. Install you website content

If you clone existing repository - then use follow:

~~~ 
cd www
git clone you-repository .
~~~

In case, if you create new repository - use composer:

~~~
docker-compose run --rm composer create-project laravel/laravel www
~~~

### 9. Using artisan, composer and npm

Webserver present standalone containers for composer, artisan and npm commands.
To run commands - use next examples:

~~~
docker-compose run --rm composer [you composer command]
docker-compose run --rm composer require spatie/laravel-permission
~~~

~~~
docker-compose run --rm artisan [you artisan command]
docker-compose run --rm artisan migrate
~~~

~~~
docker-compose run --rm npm [you npm command]
docker-compose run --rm npm build
~~~
