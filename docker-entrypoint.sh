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
    UXBOX_DATABASE_URI="\"jdbc:postgresql://${UXBOX_DATABASE_SERVER}:${UXBOX_DATABASE_PORT}/${UXBOX_DB_NAME}\""
    log "Database connection string: $UXBOX_DATABASE_URI"
fi

# ------------------------------------------------------------------------------

# TODO Find a way to only update sources if new version in source

log "Copying UXBOX Backend sources..."
rsync -rlD --delete \
    --exclude "$(echo ${UXBOX_MEDIA_DIRECTORY} | tr -d \")" \
    /usr/src/uxbox/dist/ ./

log "Copying UXBOX Backend assets..."
rsync -rlD --delete \
    /usr/src/uxbox/dist/resources/public/static "$(echo ${UXBOX_ASSETS_DIRECTORY} | tr -d \")"

# ------------------------------------------------------------------------------

# TODO Import (new) built-in collections if any found


# ------------------------------------------------------------------------------
log "Starting UXBOX backend..."
exec "$@"
