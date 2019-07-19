#!/usr/bin/env sh
set -e

# ------------------------------------------------------------------------------
echo "Initializing UXBOX Backend directories..."
mkdir -p \
    "$(echo ${UXBOX_MEDIA_DIRECTORY} | tr -d \")" \
    "$(echo ${UXBOX_ASSETS_DIRECTORY} | tr -d \")"

# ------------------------------------------------------------------------------

# TODO Find a way to only update sources if new version in source

echo "Copying UXBOX Backend sources..."
rsync -rlD --delete \
    --exclude "$(echo ${UXBOX_MEDIA_DIRECTORY} | tr -d \")" \
    /usr/src/uxbox/dist/ ./

echo "Copying UXBOX Backend assets..."
rsync -rlD --delete \
    /usr/src/uxbox/dist/resources/public/static "$(echo ${UXBOX_ASSETS_DIRECTORY} | tr -d \")"

# ------------------------------------------------------------------------------
# Import (new) built-in collections if any found

if [ -f "$(echo ${UXBOX_COLLECTIONS_CONFIG} | tr -d \")" ]; then
    log "Importing collections from config ${UXBOX_COLLECTIONS_CONFIG}..."
    clojure -Adev -m uxbox.cli.collimp $(echo ${UXBOX_COLLECTIONS_CONFIG} | tr -d \")
fi

# ------------------------------------------------------------------------------
echo "Starting UXBOX backend..."
exec "$@"
