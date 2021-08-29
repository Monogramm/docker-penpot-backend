[![License: GPL v3][uri_license_image]][uri_license]
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/Monogramm/docker-penpot-backend/Docker%20Image%20CI)](https://github.com/Monogramm/docker-penpot-backend/actions)
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

<!-- >Docker Tags -->

-   main-jdk-11-slim-buster main  (`images/main/openjdk-11-tools-deps-slim-buster/Dockerfile`)
-   main-jdk-16-alpine  (`images/main/openjdk-16-tools-deps-alpine/Dockerfile`)
-   develop-jdk-11-slim-buster develop  (`images/develop/openjdk-11-tools-deps-slim-buster/Dockerfile`)
-   develop-jdk-16-alpine  (`images/develop/openjdk-16-tools-deps-alpine/Dockerfile`)
-   1.7.4-alpha-jdk-11-slim-buster 1.7-jdk-11-slim-buster jdk-11-slim-buster 1.7.4-alpha 1.7 latest  (`images/1.7/openjdk-11-tools-deps-slim-buster/Dockerfile`)
-   1.7.4-alpha-jdk-16-alpine 1.7-jdk-16-alpine jdk-16-alpine  (`images/1.7/openjdk-16-tools-deps-alpine/Dockerfile`)
-   1.6.5-alpha-jdk-11-slim-buster 1.6-jdk-11-slim-buster 1.6.5-alpha 1.6  (`images/1.6/openjdk-11-tools-deps-slim-buster/Dockerfile`)
-   1.6.5-alpha-jdk-16-alpine 1.6-jdk-16-alpine  (`images/1.6/openjdk-16-tools-deps-alpine/Dockerfile`)

<!-- <Docker Tags -->

## How to run this image

You can use the example `docker-compose.yml` at the root of the project to start a local Penpot instance.
Feel free to update the content of `.env` to your needs.

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
