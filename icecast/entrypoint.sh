#!/usr/bin/env sh

set -e

if [ -z "$ICECAST_SOURCE_PASSWORD_FILE" ]; then
    echo "Не задан секрет ICECAST_SOURCE_PASSWORD"
    exit 1
fi

if [ -z "$ICECAST_RELAY_PASSWORD_FILE" ]; then
    echo "Не задан секрет ICECAST_RELAY_PASSWORD"
    exit 1
fi

if [ -z "$ICECAST_ADMIN_USERNAME_FILE" ]; then
    echo "Не задан секрет ICECAST_ADMIN_USERNAME"
    exit 1
fi

if [ -z "$ICECAST_ADMIN_PASSWORD_FILE" ]; then
    echo "Не задан секрет ICECAST_ADMIN_PASSWORD"
    exit 1
fi

ICECAST_SOURCE_PASSWORD=$(cat "$ICECAST_SOURCE_PASSWORD_FILE")
ICECAST_RELAY_PASSWORD=$(cat "$ICECAST_RELAY_PASSWORD_FILE")
ICECAST_ADMIN_USERNAME=$(cat "$ICECAST_ADMIN_USERNAME_FILE")
ICECAST_ADMIN_PASSWORD=$(cat "$ICECAST_ADMIN_PASSWORD_FILE")

xmlstarlet ed \
    -u "/icecast/authentication/source-password" -v "${ICECAST_SOURCE_PASSWORD}" \
    -u "/icecast/authentication/relay-password" -v "${ICECAST_RELAY_PASSWORD}" \
    -u "/icecast/authentication/admin-user" -v "${ICECAST_ADMIN_USERNAME}" \
    -u "/icecast/authentication/admin-password" -v "${ICECAST_ADMIN_PASSWORD}" \
    /etc/icecast2/icecast.xml > /tmp/icecast.xml

if [ -z "$(xmlstarlet sel -t -v '/icecast/authentication/source-password' /tmp/icecast.xml 2>/dev/null)" ]; then
    echo "Неверно передан ICECAST_SOURCE_PASSWORD"
    exit 1
fi

if [ -z "$(xmlstarlet sel -t -v '/icecast/authentication/relay-password' /tmp/icecast.xml 2>/dev/null)" ]; then
    echo "Неверно передан ICECAST_RELAY_PASSWORD"
    exit 1
fi

if [ -z "$(xmlstarlet sel -t -v '/icecast/authentication/admin-user' /tmp/icecast.xml 2>/dev/null)" ]; then
    echo "Неверно передан ICECAST_ADMIN_USERNAME"
    exit 1
fi

if [ -z "$(xmlstarlet sel -t -v '/icecast/authentication/admin-password' /tmp/icecast.xml 2>/dev/null)" ]; then
    echo "Неверно передан ICECAST_ADMIN_PASSWORD"
    exit 1
fi

exec "$@"