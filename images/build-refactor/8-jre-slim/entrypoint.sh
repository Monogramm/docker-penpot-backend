#!/usr/bin/env sh
set -e

echo "Setting up UXBOX Backend..."

mkdir -p \
    "${UXBOX_MEDIA_DIRECTORY}" \
    "${UXBOX_ASSETS_DIRECTORY}"

echo 'Running UXBOX backend...'
exec "$@"
