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
    UXBOX_DATABASE_URI="\"jdbc:postgresql://$(echo ${UXBOX_DATABASE_SERVER} | tr -d '"'):${UXBOX_DATABASE_PORT}/$(echo ${UXBOX_DATABASE_NAME} | tr -d '"')\""
    log "Database connection string: $UXBOX_DATABASE_URI"
fi

# ------------------------------------------------------------------------------

# TODO Find a way to only update sources if new version in source

log "Copying UXBOX Backend sources..."
rsync -rlD --delete \
    --exclude "$(echo ${UXBOX_MEDIA_DIRECTORY} | tr -d \")" \
    /usr/src/uxbox/dist/ \
    ./

log "Copying UXBOX Backend assets..."
rsync -rlD --delete \
    /usr/src/uxbox/dist/resources/public/static \
    "$(echo ${UXBOX_ASSETS_DIRECTORY} | tr -d \")"

log "Copying UXBOX default media..."
rsync -rlD \
    /usr/src/media \
    /srv/media

# ------------------------------------------------------------------------------
# Import (new) built-in collections if any found

if [ -f "$(echo ${UXBOX_COLLECTIONS_CONFIG} | tr -d \")" ]; then
    log "Importing collections from config ${UXBOX_COLLECTIONS_CONFIG}..."
    clojure -Adev -m uxbox.cli.collimp $(echo ${UXBOX_COLLECTIONS_CONFIG} | tr -d \")
fi

# ------------------------------------------------------------------------------
log "Starting UXBOX backend..."
exec "$@"
