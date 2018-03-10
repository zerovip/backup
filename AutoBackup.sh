#!/bin/sh
cp ~/.zshrc ~/backup/backup/
cp ~/.vimrc ~/backup/backup/
cp ~/notes ~/backup/backup/
cp ~/backup/AutoBackup.sh ~/backup/backup/
cp /etc/fstab ~/backup/backup/
cp ~/.config/ibus/rime/default.custom.yaml ~/backup/backup/
###  cp /etc/udev/rules.d/90-android-tethering.rules ~/backup/backup/
###  cp /etc/systemd/network/50-enp0s20u2.network ~/backup/backup/
pacman -Qeq | sort > ~/backup/backup/alpkglist
pacman -Qmq | sort > ~/backup/backup/otpkglist
comm -23 ~/backup/backup/alpkglist ~/backup/backup/otpkglist > ~/backup/backup/pkglist
cp ~/.mozilla/firefox/3cky76on.default/chrome/userChrome.css ~/backup/backup/
cd ~/backup/backup
git add .
date=`date +%Y%m%d`
git commit -m "Auto Backuping on "$date
git push
