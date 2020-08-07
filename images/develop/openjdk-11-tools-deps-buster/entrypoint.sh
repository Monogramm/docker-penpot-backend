#!/usr/bin/env sh
set -e

log() {
  echo "[$(date +%Y-%m-%dT%H:%M:%S%:z)] $@"
}

# ------------------------------------------------------------------------------
log "Initializing UXBOX Backend directories..."
mkdir -p \
    "$(echo ${UXBOX_MEDIA_DIRECTORY} | tr -d \")" \
    "$(echo ${UXBOX_ASSETS_DIRECTORY} | tr -d \")"

# ------------------------------------------------------------------------------

if [ -z "$UXBOX_DATABASE_URI" ]; then
    log "Initializing database connection string..."
    UXBOX_DATABASE_URI="\"postgresql://$(echo ${UXBOX_DATABASE_SERVER} | tr -d '"'):${UXBOX_DATABASE_PORT}/$(echo ${UXBOX_DATABASE_NAME} | tr -d '"')\""
    log "Database connection string: $UXBOX_DATABASE_URI"
fi

# ------------------------------------------------------------------------------

# TODO Find a way to only update sources if new version in source

log "Copying UXBOX Backend sources..."
rsync -rlD --delete \
    --exclude "$(echo ${UXBOX_MEDIA_DIRECTORY} | tr -d \")" \
    /usr/src/uxbox/target/dist/ \
    ./

log "Copying UXBOX Backend assets..."
rsync -rlD --delete \
    /usr/src/uxbox/target/dist/resources/public/static \
    "$(echo ${UXBOX_ASSETS_DIRECTORY} | tr -d \")"

log "Copying UXBOX default media..."
rsync -rlD \
    /usr/src/media \
    /srv/media

# ------------------------------------------------------------------------------
# Import (new) built-in collections if any found

if [ -n "${UXBOX_COLLECTIONS_CONFIG}" ]; then
    TEMP_UXBOX_COLLECTIONS_CONFIG=$(echo ${UXBOX_COLLECTIONS_CONFIG} | tr -d \")

    if [ -f "${TEMP_UXBOX_COLLECTIONS_CONFIG}" ] && [ ! -f "${TEMP_UXBOX_COLLECTIONS_CONFIG}.loaded" ]; then
        log "Importing collections from config ${UXBOX_COLLECTIONS_CONFIG}..."
        clojure -Adev -m uxbox.cli.collimp "${TEMP_UXBOX_COLLECTIONS_CONFIG}"
        touch "${TEMP_UXBOX_COLLECTIONS_CONFIG}.loaded"
    else
        log "Collections from config ${UXBOX_COLLECTIONS_CONFIG} already imported."
    fi

    TEMP_UXBOX_COLLECTIONS_CONFIG=
fi

# ------------------------------------------------------------------------------
# Generate demo data

if [ -n "${UXBOX_DEMO_DATA}" ]; then
    if [ ! -e ~/.fixtures-loaded ]; then
        log "Loading fixtures..."
        clojure -Adev -m uxbox.fixtures
        touch ~/.fixtures-loaded
        log "Loaded fixtures."
    else
        log "Fixtures already loaded."
    fi
fi

# ------------------------------------------------------------------------------
log "Starting UXBOX backend..."
exec "$@"
