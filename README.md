[![License: GPL v3][uri_license_image]][uri_license]
[![Build Status](https://travis-ci.org/Monogramm/docker-penpot-backend.svg)](https://travis-ci.org/Monogramm/docker-penpot-backend)
[![Docker Automated buid](https://img.shields.io/docker/cloud/build/monogramm/docker-penpot-backend.svg)](https://hub.docker.com/r/monogramm/docker-penpot-backend/)
[![Docker Pulls](https://img.shields.io/docker/pulls/monogramm/docker-penpot-backend.svg)](https://hub.docker.com/r/monogramm/docker-penpot-backend/)
[![](https://images.microbadger.com/badges/version/monogramm/docker-penpot-backend.svg)](https://microbadger.com/images/monogramm/docker-penpot-backend)
[![](https://images.microbadger.com/badges/image/monogramm/docker-penpot-backend.svg)](https://microbadger.com/images/monogramm/docker-penpot-backend)

# Penpot Backend Docker image

Docker image for Penpot Backend.

🚧 **This image is still in beta!**

## What is Penpot

Penpot is The Open-Source prototyping tool.

> <https://www.penpot.app/>

> <https://github.com/penpot/penpot>

## Supported tags

<https://hub.docker.com/r/monogramm/docker-penpot-backend/>

-   `develop` (`/images/develop/openjdk-11-tools-deps-slim-buster`)
-   `stable` (`/images/main/openjdk-11-tools-deps-slim-buster`)
-   `latest` (`/images/1.0/openjdk-11-tools-deps-slim-buster`)

<!--
-   `11-slim-buster`
-   `11-buster`
-   `14-slim-buster`
-   `14-buster`
-   `14-alpine`
-   `15-slim-buster`
-   `15-buster`
-   `15-alpine`
-->

## How to run this image ?

### Persistent data

The Penpot installation and most data are stored in the database (assets are stored separately depending on configuration). The docker daemon will store that data within the docker directory `/var/lib/docker/volumes/...`. That means your data is saved even if the container crashes, is stopped or deleted.

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

The backend supports dynamic configuration through environment variables.
Checkout Penpot documentation to get the list and their behavior: <https://github.com/penpot/penpot/blob/develop/docs/05-Configuration-Guide.md#backend>

## Questions / Issues

If you got any questions or problems using the image, please visit our [Github Repository](https://github.com/Monogramm/docker-penpot-backend) and write an issue.

[uri_license]: http://www.gnu.org/licenses/gpl.html

[uri_license_image]: https://img.shields.io/badge/License-GPL%20v3-blue.svg

