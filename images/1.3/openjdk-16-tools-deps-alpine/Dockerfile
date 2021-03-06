FROM monogramm/docker-penpot-builder:develop as builder

ARG PENPOT_VERSION=1.3.0-alpha

# Download source from github
ADD https://github.com/penpot/penpot/archive/${PENPOT_VERSION}.tar.gz /tmp/penpot.tar.gz
# or copy backend from source and build release
#COPY . /home/penpot/penpot-${PENPOT_VERSION}/backend

WORKDIR /home/penpot

RUN set -ex; \
    tar -xzf /tmp/penpot.tar.gz --strip=1; \
    rm -f /tmp/penpot.tar.gz;

WORKDIR /home/penpot/backend

# Fetch dependencies (cache them on this step) and build
RUN set -ex; \
    clojure -Stree; \
    ./scripts/build.sh; \
    ls -al ./target/dist


# Once application has been built, prepare production image
FROM clojure:openjdk-16-tools-deps-alpine

ENV GLIBC_VERSION=2.31-r0 \
    LANG=en_US.UTF-8 \
    LC_ALL=C.UTF-8

# Add dependencies needed by penpot
RUN set -ex; \
    apk update; \
    apk add --no-cache \
        bash \
        curl \
        gnupg \
        imagemagick \
        libwebp \
        rsync \
    ; \
    rm -rf /var/cache/apk/*; \
    wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk"; \
    apk add --no-cache --allow-untrusted "glibc-${GLIBC_VERSION}.apk"; \
    rm "glibc-${GLIBC_VERSION}.apk"


ARG EXTERNAL_UID=1000

# add new user
RUN set -ex; \
    adduser \
        --disabled-password \
        -u "$EXTERNAL_UID" \
        -D penpot \
    ;

ENV PENPOT_HTTP_SERVER_PORT=6060 \
    PENPOT_HTTP_SERVER_DEBUG=false \
    PENPOT_PUBLIC_URI=http://localhost/ \
    PENPOT_DATABASE_URI= \
    PENPOT_DATABASE_USERNAME=penpot \
    PENPOT_DATABASE_PASSWORD=youshouldoverwritethiswithsomethingelse \
    PENPOT_DATABASE_NAME=penpot \
    PENPOT_DATABASE_SERVER=127.0.0.1 \
    PENPOT_DATABASE_PORT=5432 \
    PENPOT_SMTP_ENABLED=false \
    PENPOT_SMTP_DEFAULT_REPLY_TO=no-reply@penpot.app \
    PENPOT_SMTP_DEFAULT_FROM=no-reply@penpot.app \
    PENPOT_SMTP_HOST=127.0.0.1 \
    PENPOT_SMTP_PORT=25 \
    PENPOT_SMTP_USER=penpot \
    PENPOT_SMTP_PASSWORD=youshouldoverwritethiswithsomethingelse \
    PENPOT_SMTP_SSL=false \
    PENPOT_SMTP_TLS=false \
    PENPOT_SMTP_ENABLED=false \
    PENPOT_REGISTRATION_ENABLED=true \
    PENPOT_SECRET=5qjiAn-QUpawUNqGP10UZKklSqbLKcdGY3sJpq0UUACpVXGg2HOFJCBejDWVHskhRyp7iHb4rjOLXX2ZjF-5cw

# Add penpot as provided by builder and create directories
COPY --chown=penpot:penpot --from=builder /root/.m2 ~/.m2
COPY --chown=penpot:penpot --from=builder /home/penpot/backend/target /home/penpot

# Add entrypoint
COPY --chown=penpot:penpot ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["./run.sh"]

WORKDIR /home/penpot/dist

VOLUME [ "/home/penpot/resources/public", "/opt/data" ]

EXPOSE 6060

ARG VERSION=1.3.0-alpha
ARG VCS_REF
ARG BUILD_DATE

# Keep track of image version
RUN set -ex; \
    sed -i -re "s/\%version\%/$VERSION/g" ./main/app/config.clj;

USER penpot

LABEL maintainer="Monogramm Maintainers <opensource at monogramm dot io>" \
    version=$VERSION \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/Monogramm/docker-penpot-backend" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="PENPOT (backend) - The Open-Source prototyping tool" \
    org.label-schema.description="The open-source solution for design and prototyping" \
    org.label-schema.url="https://www.penpot.app/" \
    org.label-schema.vendor="PENPOT" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0" \
    org.opencontainers.image.source="https://github.com/Monogramm/docker-penpot-backend" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.title="Penpot (backend) - The Open-Source prototyping tool" \
    org.opencontainers.image.description="The open-source solution for design and prototyping" \
    org.opencontainers.image.url="https://www.penpot.app/" \
    org.opencontainers.image.vendor="Penpot" \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.authors="Monogramm maintainers <opensource at monogramm dot io>"
