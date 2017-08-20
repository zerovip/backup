#!/bin/sh
cp ~/.zshrc ~/backup/backup/
cp ~/.vimrc ~/backup/backup/
cp ~/notes ~/backup/backup/
cp ~/backup/AutoBackup.sh ~/backup/backup/
cp /etc/fstab ~/backup/backup
cp /etc/udev/rules.d/90-android-tethering.rules ~/backup/backup/
cp /etc/systemd/network/50-enp0s20u2.network ~/backup/backup/
cd ~/backup/backup
git add .
date=`date +%Y%m%d`
git commit -m "Auto Backuping on "$date
git push
