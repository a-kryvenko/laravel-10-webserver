# Webserver on docker containers for Laravel 10.0

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/badges/StandWithUkraine.svg)](https://stand-with-ukraine.pp.ua)

Based on **[docker-webserver](https://github.com/a-kryvenko/docker-webserver)**.

Webserver included:
- MySQL
- PHP
- Nginx
- composer
- letsencrypt SSL certificates
- cloud backups

## Before starting

1. **[Prepare](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-22-04)** server
2. **[Install](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)** **docker**
3. **[Install](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04)** **docker-compose**

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
- <b>AWS_S3_LOCAL_MOUNT_POINT</b> - path to the local folder where we mount the cloud storage;
- <b>MAIL_SMTP_HOST</b> - smpt host for sending mail, e.g. <b>smtp.gmail.com</b>;
- <b>MAIL_SMTP_PORT</b> - smpt port. Default 25;
- <b>MAIL_SMTP_USER</b> - smpt username;
- <b>MAIL_SMTP_PASSWORD</b> - smtp password.

Separately, it is worth mentioning **COMPOSE_FILE**. Depending on the environment
we are launching a website - we need different services. For example, locally - you
only need a base app and a cloud for backups:

> dc-app.yml:dc-cloud.yml

For **dev** server - backups and https:

> dc-app.yml:dc-https.yml:dc-cloud.yml

For **production** server - whole set:
> dc-app.yml:dc-https.yml:dc-cloud.yml:dc-production.yml

Also you may need to open database ports on dev server (for example, for PhpStorm database inspect).
Ports setting up in compose-dev.yml, so in this case you need:
> dc-app.yml:dc-dev.yml

### 4. Create folder for website content

~~~ 
mkdir www
~~~

### 5. Build images and up server

~~~
docker-compose build \  
docker-compose up -d
~~~

### 6. If https required, then run script for creating certificates

~~~
./cgi-bin/prepare-certbot.sh
~~~

### 7. Initialize crontab

~~~ 
./cgi-bin/prepare-crontab.sh
~~~

### 8. Install you website content

~~~ 
cd www
git clone you-repository .
~~~
