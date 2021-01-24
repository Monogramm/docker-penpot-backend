[![License: GPL v3][uri_license_image]][uri_license]
[![Build Status](https://travis-ci.org/Monogramm/docker-penpot-backend.svg)](https://travis-ci.org/Monogramm/docker-penpot-backend)
[![Docker Automated buid](https://img.shields.io/docker/cloud/build/monogramm/docker-penpot-backend.svg)](https://hub.docker.com/r/monogramm/docker-penpot-backend/)
[![Docker Pulls](https://img.shields.io/docker/pulls/monogramm/docker-penpot-backend.svg)](https://hub.docker.com/r/monogramm/docker-penpot-backend/)
[![](https://images.microbadger.com/badges/version/monogramm/docker-penpot-backend.svg)](https://microbadger.com/images/monogramm/docker-penpot-backend)
[![](https://images.microbadger.com/badges/image/monogramm/docker-penpot-backend.svg)](https://microbadger.com/images/monogramm/docker-penpot-backend)

# Penpot Backend Docker image

Docker image for Penpot Backend.

🚧 **This image is still in development!**

## What is Penpot ?

Penpot is The Open-Source prototyping tool.

> <https://www.penpot.app/>

> <https://github.com/penpot/penpot>

## Supported tags

<https://hub.docker.com/r/monogramm/docker-penpot-backend/>

-   Branch `master`
    -   `11-slim` `latest`
    -   `11`
    -   `14-slim`
    -   `14`
    -   `14-alpine`
    -   `15-slim`
    -   `15`
    -   `15-alpine`
-   Branch `develop`
    -   `develop`

## How to run this image ?

### Persistent data

The Penpot installation and all data are stored in the database (file uploads, etc). The docker daemon will store that data within the docker directory `/var/lib/docker/volumes/...`. That means your data is saved even if the container crashes, is stopped or deleted.

To make your data persistent to upgrading and get access for backups is using named docker volume or mount a host folder. To achieve this you need one volume for your database container.

Database:

-   `/var/lib/mysql` MySQL / MariaDB Data
-   `/var/lib/postgresql/data` PostgreSQL Data

```console
$ docker run -d \
    -v db:/var/lib/postgresql/data \
    postgresql
```

### Auto configuration via environment variables

The following environment variables are also honored for configuring your Penpot instance:

Available at runtime:

-   `-e LANG=...` (defaults to `en_US.UTF-8`)
-   `-e LC_ALL=...` (defaults to `C.UTF-8`)
-   `-e Penpot_HTTP_SERVER_PORT=...` (defaults to `6060`)
-   `-e Penpot_HTTP_SERVER_DEBUG=...` (defaults to `false`)
-   `-e Penpot_HTTP_SERVER_CORS=...` (defaults to `http://localhost:3449`)
-   `-e Penpot_DATABASE_USERNAME="..."` (defaults to `penpot`)
-   `-e Penpot_DATABASE_PASSWORD="..."` (defaults to `youshouldoverwritethiswithsomethingelse`)
-   `-e Penpot_DATABASE_URI="..."` (defaults to ` `, will be computed based on other DATABASE parameters if empty)
-   `-e Penpot_DATABASE_NAME="..."` (defaults to `penpot`)
-   `-e Penpot_DATABASE_SERVER="..."` (defaults to `127.0.0.1`)
-   `-e Penpot_DATABASE_PORT=...` (defaults to `5432`)
-   `-e Penpot_MEDIA_DIRECTORY=...` (defaults to `resources/public/media`)
-   `-e Penpot_MEDIA_URI=...` (defaults to `http://localhost:6060/media/`)
-   `-e Penpot_ASSETS_DIRECTORY=...` (defaults to `resources/public/static`)
-   `-e Penpot_ASSETS_URI=...` (defaults to `http://localhost:6060/static/`)
-   `-e Penpot_EMAIL_REPLY_TO="..."` (defaults to `no-reply@penpot.io`)
-   `-e Penpot_EMAIL_FROM="..."` (defaults to `no-reply@penpot.io`)
-   `-e Penpot_SMTP_HOST="..."` (defaults to `127.0.0.1`)
-   `-e Penpot_SMTP_PORT=...` (defaults to `25`)
-   `-e Penpot_SMTP_USER="..."` (defaults to `penpot`)
-   `-e Penpot_SMTP_PASSWORD="..."` (defaults to `youshouldoverwritethiswithsomethingelse`)
-   `-e Penpot_SMTP_SSL=...` (defaults to `false`)
-   `-e Penpot_SMTP_TLS=...` (defaults to `false`)
-   `-e Penpot_SMTP_ENABLED=...` (defaults to `false`)
-   `-e Penpot_REGISTRATION_ENABLED=...` (defaults to `true`)
-   `-e Penpot_SECRET="..."` (defaults to `5qjiAn-QUpawUNqGP10UZKklSqbLKcdGY3sJpq0UUACpVXGg2HOFJCBejDWVHskhRyp7iHb4rjOLXX2ZjF-5cw`)

**Important note:** make sure to use quotation marks for string variables or the backend might try to interpret the values as symbols and have weird issues.

## Questions / Issues

If you got any questions or problems using the image, please visit our [Github Repository](https://github.com/Monogramm/docker-penpot-backend) and write an issue.

[uri_license]: http://www.gnu.org/licenses/gpl.html

[uri_license_image]: https://img.shields.io/badge/License-GPL%20v3-blue.svg

