FROM monogramm/docker-uxbox-builder:latest

ARG VERSION=develop

# Download source from github
ADD https://github.com/uxbox/uxbox/archive/${VERSION}.tar.gz /tmp/uxbox.tar.gz
# or copy backend from source and build release
#COPY . /home/uxbox/uxbox-${VERSION}/backend

RUN set -ex; \
    mkdir -p /home/uxbox; \
    cd /home/uxbox; \
    tar -xzf /tmp/uxbox.tar.gz; \
    rm -f /tmp/uxbox.tar.gz; \
    mv /home/uxbox/uxbox-${VERSION}/backend /home/uxbox/; \
    [ ! -f /home/uxbox/uxbox-${VERSION}/sample_media ] || mv /home/uxbox/uxbox-${VERSION}/sample_media /home/uxbox/; \
    mkdir -p /home/uxbox/sample_media; \
    rm -rf /home/uxbox/uxbox-${VERSION}; \
    cd /home/uxbox/backend; \
    ./scripts/prepare-release.sh ./ ./dist/; \
    tar czf uxbox-backend.tar.gz ./dist; \
    rm -rf ./dist/*; \
    mv uxbox-backend.tar.gz ./dist/uxbox-backend.tar.gz


# Once application has been built, prepare production image
FROM openjdk:8-jre-slim

ENV CLOJURE_VERSION=1.10.1.458 \
    LANG=en_US.UTF-8 \
    LC_ALL=C.UTF-8

# Add dependencies needed by uxbox
RUN set -ex; \
    apt-get update -yq;  \
    apt-get install -yq \
        curl \
        imagemagick \
        rsync \
        webp \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    curl -L -o clojure-linux-install.sh "https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh"; \
    chmod +x clojure-linux-install.sh; \
    ./clojure-linux-install.sh; \
    rm -rf clojure-linux-install.sh; \
    clojure -h

# Add uxbox as provided by builder and create directories
COPY --from=0 /home/uxbox/backend/dist/uxbox-backend.tar.gz /usr/src/uxbox-backend.tar.gz
COPY --from=0 /home/uxbox/sample_media /usr/src/media
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
    UXBOX_DATABASE_URI= \
    UXBOX_DATABASE_USERNAME="uxbox" \
    UXBOX_DATABASE_PASSWORD="youshouldoverwritethiswithsomethingelse" \
    UXBOX_DATABASE_NAME="uxbox" \
    UXBOX_DATABASE_SERVER="127.0.0.1" \
    UXBOX_DATABASE_PORT=5432 \
    UXBOX_MEDIA_DIRECTORY="resources/public/media" \
    UXBOX_MEDIA_URI="http://localhost:6060/media/" \
    UXBOX_ASSETS_DIRECTORY="resources/public/static" \
    UXBOX_ASSETS_URI="http://localhost:6060/static/" \
    UXBOX_COLLECTIONS_CONFIG="/srv/media/config.edn" \
    UXBOX_EMAIL_REPLY_TO="no-reply@uxbox.io" \
    UXBOX_EMAIL_FROM="no-reply@uxbox.io" \
    UXBOX_SMTP_HOST="127.0.0.1" \
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

ARG VERSION=develop
ARG VCS_REF
ARG BUILD_DATE

LABEL maintainer="Monogramm Maintainers <opensource at monogramm dot io>" \
    version=$VERSION \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/Monogramm/docker-uxbox-backend" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="UXBOX (backend) - The Open-Source prototyping tool" \
    org.label-schema.description="The open-source solution for design and prototyping" \
    org.label-schema.url="https://www.uxbox.io/" \
    org.label-schema.vendor="UXBOX" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["clojure", "-m", "uxbox.main"]
