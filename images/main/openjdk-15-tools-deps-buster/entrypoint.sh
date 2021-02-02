#!/usr/bin/env sh
set -e

log() {
  echo "[$(date +%Y-%m-%dT%H:%M:%S%:z)] $*"
}

# ------------------------------------------------------------------------------

if [ -z "${PENPOT_DATABASE_URI}" ]; then
    log "Initializing database connection string..."
    PENPOT_DATABASE_URI="postgresql://${PENPOT_DATABASE_SERVER}:${PENPOT_DATABASE_PORT}/${PENPOT_DATABASE_NAME}"
    log "Database connection string: ${PENPOT_DATABASE_URI}"
fi

# ------------------------------------------------------------------------------

if [ -n "${PENPOT_MEDIA_DIRECTORY}" ] && [ -d /home/penpot/backend/target/dist ]; then
    log "Initializing Backend sources..."
    mkdir -p \
        "${PENPOT_MEDIA_DIRECTORY}"
    log "Copying Backend sources..."
    rsync -rlD --delete \
        --exclude "${PENPOT_MEDIA_DIRECTORY}" \
        /home/penpot/backend/target/dist/ \
        ./
fi

if [ -n "${PENPOT_ASSETS_DIRECTORY}" ] && [ -d /home/penpot/backend/target/dist/resources/public/static ]; then
    log "Initializing Backend assets..."
    mkdir -p \
        "${PENPOT_ASSETS_DIRECTORY}"
    log "Copying Backend assets..."
    rsync -rlD --delete \
        /home/penpot/backend/target/dist/resources/public/static \
        "${PENPOT_ASSETS_DIRECTORY}"
fi

if [ -d /usr/src/media ]; then
    log "Copying default media..."
    rsync -rlD \
        /usr/src/media \
        /opt/data
fi

# ------------------------------------------------------------------------------
# Generate demo data

if [ -n "${PENPOT_DEMO_DATA}" ]; then
    if [ ! -e ~/.fixtures-loaded ]; then
        log "Loading fixtures..."
        clojure -Adev -m penpot.fixtures
        touch ~/.fixtures-loaded
        log "Loaded fixtures."
    else
        log "Fixtures already loaded."
    fi
fi

# ------------------------------------------------------------------------------
log "Starting command..."
exec "$@"
