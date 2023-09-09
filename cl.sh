#!/bin/bash

##Обновляем пакеты и ставим борг
apt update
apt install borgbackup -y

##Создаем 2 юнита systemd. 1 сервис создает бакап и подчищает старые файлы в соответсвии с условием. 2 таймер запускает бэк ап каждые 5 минут
echo '[Unit]
##Описание сервиса
Description=Borg Backup
[Service]
##Тип одноразовый запуск
Type=oneshot
##пароль репозитория который мы зададим
Environment="BORG_PASSPHRASE=1234"
##название репозитория
Environment=REPO=borg@192.168.50.10:Myback
##точка бэкапа
Environment=BACKUP_TARGET=/etc
##команда создания бэкапа
ExecStart=/bin/borg create \
    ${REPO}::etc-{now:%%Y-%%m-%%d_%%H:%%M:%%S} ${BACKUP_TARGET}
##проверка бэкапа
ExecStart=/bin/borg check ${REPO}
##настройка глубины архива
ExecStart=/bin/borg prune \
    --keep-daily  90      \
    --keep-monthly 12     \
    --keep-yearly  1       \
    ${REPO}' > /etc/systemd/system/borg-backup.service

echo "[Unit]
Description=Borg Backup
##Таймер который будет запускать сервис 1 раз в 5 минут
[Timer]
OnUnitActiveSec=5min

[Install]
WantedBy=timers.target
" > /etc/systemd/system/borg-backup.timer
#команды для напоминания
#ssh-keygen -t rsa
#borg init --encryption=repokey borg@192.168.50.10:Myback
#systemctl enable borg-backup.timer
#systemctl start borg-backup.service
#systemctl start borg-backup.timer
#borg list borg@192.168.50.10:Myback
#systemctl list-timers --all
#borg extract borg@192.168.50.10:Myback::etc-2023-09-09_12:15:09 etc/apt
