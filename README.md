Скрипт проверки работы процесса и доступности api сервиса с логированием. 
Таймер на выполнение каждую минуту.

1. monitor.service и monitor.timer нужно поместить в /etc/systemd/system

2. прописать путь к исполняемому файлу скрипта в monitor.service

3. Перезапустить демона systemd и новые сервисы с добавлением в автозагрузку:
sudo
    systemctl daemon-reload
    systemctl start monitor.service
    systemctl enable monitor.service
    systemctl start monitor.timer
    systemctl enable monitor.timer

4. проверить работу сервиса можно в журнале логов: /var/log/monitoring.log
