FROM monogramm/docker-penpot-builder:develop as builder

ARG VERSION=develop

# Download source from github
ADD https://github.com/penpot/penpot/archive/${VERSION}.tar.gz /tmp/penpot.tar.gz
# or copy backend from source and build release
#COPY . /home/penpot/penpot-${VERSION}/backend

RUN set -ex; \
    mkdir -p /home/penpot; \
    cd /home/penpot; \
    tar -xzf /tmp/penpot.tar.gz --strip=1; \
    rm -f /tmp/penpot.tar.gz;


WORKDIR /home/penpot/backend

# Fetch dependencies (cache them on this step) and build
RUN set -ex; \
    clojure -Stree; \
    ./scripts/build.sh; \
    ls -al ./target/dist


# Once application has been built, prepare production image
FROM clojure:openjdk-11-tools-deps-slim-buster

ENV LANG=en_US.UTF-8 \
    LC_ALL=C.UTF-8

# Add dependencies needed by penpot
RUN set -ex; \
    apt-get update -yq;  \
    apt-get install -yq \
        curl \
        imagemagick \
        rsync \
        webp \
    ; \
    rm -rf /var/lib/apt/lists/*


ARG EXTERNAL_UID=1000

# add new user
RUN set -ex; \
    useradd \
        -u "$EXTERNAL_UID" \
        -U \
        penpot \
    ; \
    usermod -aG sudo penpot

USER penpot

# Add penpot as provided by builder and create directories
COPY --chown=penpot:penpot --from=builder /root/.m2 ~/.m2
COPY --chown=penpot:penpot --from=builder /home/penpot /home/penpot

# Add entrypoint
COPY --chown=penpot:penpot ./entrypoint.sh /entrypoint.sh

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
    PENPOT_SMTP_DEFAULT_REPLY_TO=no-reply@penpot.io \
    PENPOT_SMTP_DEFAULT_FROM=no-reply@penpot.io \
    PENPOT_SMTP_HOST=127.0.0.1 \
    PENPOT_SMTP_PORT=25 \
    PENPOT_SMTP_USER=penpot \
    PENPOT_SMTP_PASSWORD=youshouldoverwritethiswithsomethingelse \
    PENPOT_SMTP_SSL=false \
    PENPOT_SMTP_TLS=false \
    PENPOT_SMTP_ENABLED=false \
    PENPOT_REGISTRATION_ENABLED=true \
    PENPOT_SECRET=5qjiAn-QUpawUNqGP10UZKklSqbLKcdGY3sJpq0UUACpVXGg2HOFJCBejDWVHskhRyp7iHb4rjOLXX2ZjF-5cw

WORKDIR /home/penpot/backend

VOLUME [ "/home/penpot/resources/public", "/opt/data" ]

EXPOSE 6060

ARG VERSION=develop
ARG VCS_REF
ARG BUILD_DATE

LABEL maintainer="Monogramm Maintainers <opensource at monogramm dot io>" \
    version=$VERSION \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/Monogramm/docker-penpot-backend" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="PENPOT (backend) - The Open-Source prototyping tool" \
    org.label-schema.description="The open-source solution for design and prototyping" \
    org.label-schema.url="https://www.penpot.io/" \
    org.label-schema.vendor="PENPOT" \
    org.label-schema.version=$VERSION \
    org.label-schema.schema-version="1.0"

ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["./target/dist/run.sh"]
