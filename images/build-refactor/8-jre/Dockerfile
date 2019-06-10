FROM monogramm/docker-uxbox-builder:latest

ENV LEIN_ROOT=TRUE \
    UXBOX_VERSION=build-refactor

# Download source from github
ADD https://github.com/uxbox/uxbox/archive/${UXBOX_VERSION}.tar.gz /tmp/uxbox.tar.gz
# or copy backend from source and build release
#COPY . /home/uxbox/uxbox-${UXBOX_VERSION}/backend

RUN set -ex; \
    mkdir -p /home/uxbox; \
    cd /home/uxbox; \
    tar -xzf /tmp/uxbox.tar.gz; \
    rm -f /tmp/uxbox.tar.gz; \
    mv /home/uxbox/uxbox-${UXBOX_VERSION}/backend /home/uxbox/; \
    rm -rf /home/uxbox/uxbox-${UXBOX_VERSION}; \
    cd /home/uxbox/backend; \
    rm -f Dockerfile; \
    bash -c "/home/uxbox/backend/scripts/dist.sh"


# Once application has been built, prepare production image
FROM openjdk:8-jre

LABEL maintainer="Monogramm Maintainers <opensource at monogramm dot io>"

ENV LANG=en_US.UTF-8 \
    LC_ALL=C.UTF-8

RUN set -ex; \
    mkdir -p /srv/uxbox/resources/public/media; \
    mkdir -p /srv/uxbox/resources/public/static; \
    apt-get update -yq &&  \
    apt-get install -yq \
        git \
        imagemagick \
        webp \
    ; \
    apt-get update -yq; \
    apt-get install -yq \
        libbz2-dev liblzma-dev zlib1g-dev libfftw3-dev \
        libfreetype6-dev libfontconfig1-dev libxt-dev \
        libexif-dev libjpeg-dev libpng-dev libtiff-dev \
        libwmf-dev libpango1.0-dev librsvg2-bin librsvg2-dev \
        libxml2-dev libwebp-dev webp \
    ; \
    git clone https://github.com/ImageMagick/ImageMagick.git imagemagick && \
    cd imagemagick && \
    git checkout -f 7.0.8-27 && \
    ./configure --prefix=/opt/img && \
    make -j2 && \
    make install && \
    cd .. && \
    rm -rf ./imagemagick

ENV UXBOX_HTTP_SERVER_DEBUG=false \
    UXBOX_MEDIA_URI="http://localhost:6060/media/" \
    UXBOX_MEDIA_DIRECTORY="resources/public/media" \
    UXBOX_ASSETS_URI="http://localhost:6060/static/" \
    UXBOX_ASSETS_DIRECTORY="resources/public/static" \
    UXBOX_DATABASE_USERNAME="uxbox" \
    UXBOX_DATABASE_PASSWORD="youshouldoverwritethiswithsomethingelse" \
    UXBOX_DATABASE_NAME="uxbox" \
    UXBOX_DATABASE_SERVER="localhost" \
    UXBOX_DATABASE_PORT=5432 \
    UXBOX_EMAIL_REPLY_TO="no-reply@uxbox.io" \
    UXBOX_EMAIL_FROM="no-reply@uxbox.io" \
    UXBOX_SMTP_HOST="localhost" \
    UXBOX_SMTP_PORT=25 \
    UXBOX_SMTP_USER="uxbox" \
    UXBOX_SMTP_PASSWORD="youshouldoverwritethiswithsomethingelse" \
    UXBOX_SMTP_SSL=false \
    UXBOX_SMTP_TLS=false \
    UXBOX_SMTP_ENABLED=false \
    UXBOX_SECRET=""

# Add uxbox as provided by builder
COPY --from=0 /home/uxbox/backend/dist/uxbox-backend.jar /srv/uxbox/app.jar

COPY ./entrypoint.sh /entrypoint.sh
RUN set -ex; \
    chmod 755 /entrypoint.sh

WORKDIR /srv/uxbox/

VOLUME /srv/uxbox/resources/public

EXPOSE 6060

ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["java", "-jar", "app.jar"]
