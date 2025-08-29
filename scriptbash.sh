#!/bin/bash

# Путь к файлу журнала
LOG_FILE="/var/log/monitoring.log"
URL="https://search.worldbank.org/api/v3/wds?format=json&qterm=energy&display_title=water&fl=display_title&rows=2&os=20"
STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$URL")
# Проверяем наличие запущенного процесса 'NetworkManager'
if pgrep -x "NetworkManager" > /dev/null; then
    # Процесс найден, отправляем HTTPS-запрос на мониторинговый API
    if [ "$STATUS" -eq 200 ] || [ "$STATUS" -eq 300 ]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') Process is running and server responded successfully." >> "${LOG_FILE}"
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S') Server not available." >> "${LOG_FILE}"
    fi
else
    # Процесс не найден, проверяем, был ли он недавно перезагружен
    LAST_RESTART=$(journalctl -e | grep "restart NetworkManager")
    if [[ ! -z "${LAST_RESTART}" ]]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') Process was recently restarted." >> "${LOG_FILE}"
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S') There is no process." >> "${LOG_FILE}"
    fi
fi
