#!/bin/bash

##Обновляем репозиторий и устанавливаем борг
apt update
apt install borgbackup -y

##Добавляем нвоого пользователя
useradd -m borg

##Создаем папку и назначаем нового пользователя владельцем
mkdir /var/backup
chown borg:borg /var/backup

##Добавляем новый диск и монтируем его в /var/backup, папку для бекапов с клиента
sfdisk /dev/sdb << EOF
;
EOF
mkfs.ext4 /dev/sdb1
echo `blkid | grep "/dev/sdb1: UUID=" | awk '{print $2}'`"     /var/backup     ext4        defaults     0      0" >> /etc/fstab
mount -a
rm -R /var/backup/lost+found

##Создаем новому пользователю инфраструктуру для добавления rsa-ключа
mkdir /home/borg/.ssh
chown borg:borg /home/borg/.ssh
touch /home/borg/.ssh/authorized_keys
chown borg:borg /home/borg/.ssh/authorized_keys
chmod 700 /home/borg/.ssh
chmod 600 /home/borg/.ssh/authorized_keys
