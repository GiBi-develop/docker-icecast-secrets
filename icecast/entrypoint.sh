#!/usr/bin/env sh

set -e

if [ -z "$ICECAST_SOURCE_PASSWORD_FILE" ] || [ -z "$ICECAST_RELAY_PASSWORD_FILE" ] || [ -z "$ICECAST_ADMIN_USERNAME_FILE" ] || [ -z "$ICECAST_ADMIN_PASSWORD_FILE" ]; then
    echo "Заданы не все секреты."
    exit 1
fi

ICECAST_SOURCE_PASSWORD=$(cat "$ICECAST_SOURCE_PASSWORD_FILE")
ICECAST_RELAY_PASSWORD=$(cat "$ICECAST_RELAY_PASSWORD_FILE")
ICECAST_ADMIN_USERNAME=$(cat "$ICECAST_ADMIN_USERNAME_FILE")
ICECAST_ADMIN_PASSWORD=$(cat "$ICECAST_ADMIN_PASSWORD_FILE")

xmlstarlet ed \
    -u "/icecast/authentication/source-password" -v "${ICECAST_SOURCE_PASSWORD}" \
    -u "/icecast/authentication/relay-password" -v "${ICECAST_RELAY_PASSWORD}" \
    -u "/icecast/admin/username" -v "${ICECAST_ADMIN_USERNAME}" \
    -u "/icecast/admin/password" -v "${ICECAST_ADMIN_PASSWORD}" \
    /etc/icecast2/icecast.xml > /tmp/icecast.xml

if [ -z $(xmlstarlet sel -t -v "/icecast/authentication/source-password" /etc/icecast2/icecast.xml 2>/dev/null) ] ||
   [ -z $(xmlstarlet sel -t -v "/icecast/authentication/relay-password" /etc/icecast2/icecast.xml 2>/dev/null) ] ||
   [ -z $(xmlstarlet sel -t -v "/icecast/admin/username" /etc/icecast2/icecast.xml 2>/dev/null) ] ||
   [ -z $(xmlstarlet sel -t -v "/icecast/admin/password" /etc/icecast2/icecast.xml 2>/dev/null) ]; then
    echo "Заданы не все секреты."
    exit 1
fi

exec "$@"