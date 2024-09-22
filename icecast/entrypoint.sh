#!/usr/bin/env sh

set -e

xmlstarlet ed \
    -u "/icecast/authentication/source-password" -v "${ICECAST_SOURCE_PASSWORD}" \
    -u "/icecast/authentication/relay-password" -v "${ICECAST_RELAY_PASSWORD}" \
    -u "/icecast/admin/username" -v "${ICECAST_ADMIN_USERNAME}" \
    -u "/icecast/admin/password" -v "${ICECAST_ADMIN_PASSWORD}" \
    /etc/icecast2/icecast.xml > /tmp/icecast.xml

exec "$@"