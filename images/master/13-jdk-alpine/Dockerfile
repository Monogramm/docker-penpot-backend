FROM monogramm/docker-uxbox-builder:latest

ENV UXBOX_VERSION=master

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
    rm -rf ./dist; \
    rsync -avr \
        --exclude="/test" \
        --exclude="/resources/public/media" \
        --exclude="/target" \
        --exclude="/scripts" \
        --exclude="/.*" \
        ./ ./dist/; \
    tar czf uxbox-backend.tar.gz ./dist; \
    rm -rf ./dist/*; \
    mv uxbox-backend.tar.gz ./dist/uxbox-backend.tar.gz
    #./scripts/prepare-release.sh


# Once application has been built, prepare production image
FROM openjdk:13-jdk-alpine

LABEL maintainer="Monogramm Maintainers <opensource at monogramm dot io>"

ENV CLOJURE_VERSION=1.10.1.458 \
    GLIBC_VERSION=2.29-r0 \
    LANG=en_US.UTF-8 \
    LC_ALL=C.UTF-8

# Add dependencies needed by uxbox
RUN set -ex; \
    apk update; \
    apk add --no-cache \
        bash \
        curl \
        imagemagick \
        libwebp \
        rsync \
    ; \
    rm -rf /var/cache/apk/*; \
    curl -L -o clojure-linux-install.sh "https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh"; \
    chmod +x clojure-linux-install.sh; \
    ./clojure-linux-install.sh; \
    rm -rf clojure-linux-install.sh; \
    clojure -h; \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk; \
    apk add --no-cache --allow-untrusted glibc-${GLIBC_VERSION}.apk; \
    rm glibc-${GLIBC_VERSION}.apk

# Add uxbox as provided by builder and create directories
COPY --from=0 /home/uxbox/backend/dist/uxbox-backend.tar.gz /usr/src/uxbox-backend.tar.gz
RUN set -ex; \
    mkdir -p /usr/src/uxbox; \
    tar xzf /usr/src/uxbox-backend.tar.gz -C /usr/src/uxbox; \
    rm -f /usr/src/uxbox-backend.tar.gz

# Add entrypoint
COPY ./entrypoint.sh /entrypoint.sh
RUN set -ex; \
    chmod 755 /entrypoint.sh

ENV UXBOX_HTTP_SERVER_PORT=6060 \
    UXBOX_HTTP_SERVER_DEBUG=false \
    UXBOX_DATABASE_USERNAME="uxbox" \
    UXBOX_DATABASE_PASSWORD="youshouldoverwritethiswithsomethingelse" \
    UXBOX_DATABASE_NAME="uxbox" \
    UXBOX_DATABASE_SERVER="localhost" \
    UXBOX_DATABASE_PORT=5432 \
    UXBOX_MEDIA_DIRECTORY="resources/public/media" \
    UXBOX_MEDIA_URI="http://localhost:6060/media/" \
    UXBOX_ASSETS_DIRECTORY="resources/public/static" \
    UXBOX_ASSETS_URI="http://localhost:6060/static/" \
    UXBOX_EMAIL_REPLY_TO="no-reply@uxbox.io" \
    UXBOX_EMAIL_FROM="no-reply@uxbox.io" \
    UXBOX_SMTP_HOST="localhost" \
    UXBOX_SMTP_PORT=25 \
    UXBOX_SMTP_USER="uxbox" \
    UXBOX_SMTP_PASSWORD="youshouldoverwritethiswithsomethingelse" \
    UXBOX_SMTP_SSL=false \
    UXBOX_SMTP_TLS=false \
    UXBOX_SMTP_ENABLED=false \
    UXBOX_REGISTRATION_ENABLED=true \
    UXBOX_SECRET="5qjiAn-QUpawUNqGP10UZKklSqbLKcdGY3sJpq0UUACpVXGg2HOFJCBejDWVHskhRyp7iHb4rjOLXX2ZjF-5cw"

WORKDIR /srv/uxbox

VOLUME /srv/uxbox/resources/public

EXPOSE 6060

ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["clojure", "-m", "uxbox.main"]
