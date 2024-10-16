#!/usr/bin/env bash

set -e

# Функция для чтения значений из переменной или файла
get_value() {
  var_name="$1"
  file_var_name="${var_name}_FILE"

  # Проверка на наличие переменной _FILE
  if [ -n "${!file_var_name}" ]; then
    # Если переменная _FILE существует, читаем значение из файла
    if [ -f "${!file_var_name}" ]; then
      cat "${!file_var_name}"

    else
      echo "Ошибка: файл ${!file_var_name} не найден."
      exit 1
    fi
  else
    # Если переменная _FILE не существует, проверяем наличие обычной переменной
    if [ -z "${!var_name}" ]; then
      echo "Ошибка: переменная ${var_name} не задана."
      exit 1
    else
      echo "${!var_name}"
    fi
  fi
}

# Чтение переменных окружения или файлов-секретов
ICECAST_SOURCE_PASSWORD=$(get_value ICECAST_SOURCE_PASSWORD)
ICECAST_RELAY_PASSWORD=$(get_value ICECAST_RELAY_PASSWORD)
ICECAST_ADMIN_USERNAME=$(get_value ICECAST_ADMIN_USERNAME)
ICECAST_ADMIN_PASSWORD=$(get_value ICECAST_ADMIN_PASSWORD)

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