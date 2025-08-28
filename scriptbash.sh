#!/bin/bash

# Путь к файлу журнала
LOG_FILE="/var/log/monitoring.log"

# Проверяем наличие запущенного процесса 'test'
if pgrep -x "test" > /dev/null; then
    # Процесс найден, отправляем HTTPS-запрос на мониторинговый API
    if curl --output /dev/null --silent --head --fail "https://test.com/monitoring/test/api"; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') Process is running and server responded successfully." >> "${LOG_FILE}"
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S') Server not available." >> "${LOG_FILE}"
    fi
else
    # Процесс не найден, проверяем, был ли он недавно перезагружен
    LAST_RESTART=$(tail -n 1 "${LOG_FILE}" | grep "Process restarted")
    
    if [[ ! -z ${LAST_RESTART} ]]; then
        echo "$(date +'%Y-%m-%d %H:%M:%S') Process was recently restarted." >> "${LOG_FILE}"
    fi
fi
