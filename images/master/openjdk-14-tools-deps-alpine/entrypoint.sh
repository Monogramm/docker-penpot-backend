#!/usr/bin/env sh
set -e

log() {
  echo "[$(date +%Y-%m-%dT%H:%M:%S%:z)] $@"
}

# ------------------------------------------------------------------------------
log "Initializing PENPOT Backend directories..."
mkdir -p \
    "$(echo ${PENPOT_MEDIA_DIRECTORY} | tr -d \")" \
    "$(echo ${PENPOT_ASSETS_DIRECTORY} | tr -d \")"

# ------------------------------------------------------------------------------

if [ -z "$PENPOT_DATABASE_URI" ]; then
    log "Initializing database connection string..."
    PENPOT_DATABASE_URI="postgresql://$(echo ${PENPOT_DATABASE_SERVER} | tr -d '"'):${PENPOT_DATABASE_PORT}/$(echo ${PENPOT_DATABASE_NAME} | tr -d '"')
    log "Database connection string: $PENPOT_DATABASE_URI"
fi

# ------------------------------------------------------------------------------

# TODO Find a way to only update sources if new version in source

log "Copying PENPOT Backend sources..."
rsync -rlD --delete \
    --exclude "$(echo ${PENPOT_MEDIA_DIRECTORY} | tr -d \")" \
    /usr/src/penpot/target/dist/ \
    ./

log "Copying PENPOT Backend assets..."
rsync -rlD --delete \
    /usr/src/penpot/target/dist/resources/public/static \
    "$(echo ${PENPOT_ASSETS_DIRECTORY} | tr -d \")"

log "Copying PENPOT default media..."
rsync -rlD \
    /usr/src/media \
    /srv/media

# ------------------------------------------------------------------------------
# Import (new) built-in collections if any found

if [ -n "${PENPOT_COLLECTIONS_CONFIG}" ]; then
    TEMP_PENPOT_COLLECTIONS_CONFIG=$(echo ${PENPOT_COLLECTIONS_CONFIG} | tr -d \")

    if [ -f "${TEMP_PENPOT_COLLECTIONS_CONFIG}" ] && [ ! -f "${TEMP_PENPOT_COLLECTIONS_CONFIG}.loaded" ]; then
        log "Importing collections from config ${PENPOT_COLLECTIONS_CONFIG}..."
        clojure -Adev -m penpot.cli.collimp "${TEMP_PENPOT_COLLECTIONS_CONFIG}"
        touch "${TEMP_PENPOT_COLLECTIONS_CONFIG}.loaded"
    else
        log "Collections from config ${PENPOT_COLLECTIONS_CONFIG} already imported."
    fi

    TEMP_PENPOT_COLLECTIONS_CONFIG=
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
log "Starting PENPOT backend..."
exec "$@"
