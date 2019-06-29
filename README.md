
[uri_license]: http://www.gnu.org/licenses/gpl.html
[uri_license_image]: https://img.shields.io/badge/License-GPL%20v3-blue.svg

[![License: GPL v3][uri_license_image]][uri_license]
[![Build Status](https://travis-ci.org/Monogramm/docker-uxbox-backend.svg)](https://travis-ci.org/Monogramm/docker-uxbox-backend)
[![Docker Automated buid](https://img.shields.io/docker/cloud/build/monogramm/docker-uxbox-backend.svg)](https://hub.docker.com/r/monogramm/docker-uxbox-backend/)
[![Docker Pulls](https://img.shields.io/docker/pulls/monogramm/docker-uxbox-backend.svg)](https://hub.docker.com/r/monogramm/docker-uxbox-backend/)
[![](https://images.microbadger.com/badges/version/monogramm/docker-uxbox-backend.svg)](https://microbadger.com/images/monogramm/docker-uxbox-backend)
[![](https://images.microbadger.com/badges/image/monogramm/docker-uxbox-backend.svg)](https://microbadger.com/images/monogramm/docker-uxbox-backend)

# UXBOX Backend Docker image

Docker image for UXBOX Backend.

:construction: **This image is still in development!**

## What is UXBOX ?

UXBOX is The Open-Source prototyping tool.

> https://www.uxbox.io/

> https://github.com/uxbox/uxbox

## Supported tags

https://hub.docker.com/r/monogramm/docker-uxbox-backend/

* `8-jre-slim` `jre-slim` `8` `latest`
* `8-jre` `jre`
* `8-jre-alpine` `jre-alpine` `alpine`
* `11-jdk-slim` `jdk-slim` `11`
* `11-jdk` `jdk`
* `13-jdk-alpine` `jdk-alpine` `13`

## How to run this image ?

### Persistent data
The UXBOX installation and all data are stored in the database (file uploads, etc). The docker daemon will store that data within the docker directory `/var/lib/docker/volumes/...`. That means your data is saved even if the container crashes, is stopped or deleted.

To make your data persistent to upgrading and get access for backups is using named docker volume or mount a host folder. To achieve this you need one volume for your database container.

Database:
- `/var/lib/mysql` MySQL / MariaDB Data
- `/var/lib/postgresql/data` PostgreSQL Data
```console
$ docker run -d \
    -v db:/var/lib/postgresql/data \
    postgresql
```

### Auto configuration via environment variables

The following environment variables are also honored for configuring your UXBOX instance:

Available at runtime:
-	`-e LANG=...` (defaults to `en_US.UTF-8`)
-	`-e LC_ALL=...` (defaults to `C.UTF-8`)
-	`-e UXBOX_HTTP_SERVER_DEBUG=...` (defaults to `false`)
-	`-e UXBOX_MEDIA_URI=...` (defaults to `http://localhost:6060/media/`)
-	`-e UXBOX_MEDIA_DIRECTORY=...` (defaults to `resources/public/media`)
-	`-e UXBOX_ASSETS_URI=...` (defaults to `http://localhost:6060/static/`)
-	`-e UXBOX_ASSETS_DIRECTORY=...` (defaults to `resources/public/static`)
-	`-e UXBOX_DATABASE_USERNAME="..."` (defaults to `uxbox`)
-	`-e UXBOX_DATABASE_PASSWORD="..."` (defaults to `youshouldoverwritethiswithsomethingelse`)
-	`-e UXBOX_DATABASE_NAME="..."` (defaults to `uxbox`)
-	`-e UXBOX_DATABASE_SERVER="..."` (defaults to `localhost`)
-	`-e UXBOX_DATABASE_PORT=...` (defaults to `5432`)
-	`-e UXBOX_EMAIL_REPLY_TO="..."` (defaults to `no-reply@uxbox.io`)
-	`-e UXBOX_EMAIL_FROM="..."` (defaults to `no-reply@uxbox.io`)
-	`-e UXBOX_SMTP_HOST="..."` (defaults to `localhost`)
-	`-e UXBOX_SMTP_PORT=...` (defaults to `25`)
-	`-e UXBOX_SMTP_USER="..."` (defaults to `uxbox`)
-	`-e UXBOX_SMTP_PASSWORD="..."` (defaults to `youshouldoverwritethiswithsomethingelse`)
-	`-e UXBOX_SMTP_SSL=...` (defaults to `false`)
-	`-e UXBOX_SMTP_TLS=...` (defaults to `false`)
-	`-e UXBOX_SMTP_ENABLED=...` (defaults to `false`)
-	`-e UXBOX_REGISTRATION_ENABLED=...` (defaults to `true`)
-	`-e UXBOX_SECRET="..."` (defaults to `5qjiAn-QUpawUNqGP10UZKklSqbLKcdGY3sJpq0UUACpVXGg2HOFJCBejDWVHskhRyp7iHb4rjOLXX2ZjF-5cw`)

**Important note:** make sure to use quotation marks for string variables or the backend might try to interpret the values as symbols and have weird issues.

# Questions / Issues
If you got any questions or problems using the image, please visit our [Github Repository](https://github.com/Monogramm/docker-uxbox-backend) and write an issue.
