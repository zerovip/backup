#!/bin/sh
cp ~/.zshrc ~/backup/backup/
cp ~/.vimrc ~/backup/backup/
cp ~/notes ~/backup/backup/
cp ~/backup/AutoBackup.sh ~/backup/backup/
cd ~/backup/backup
git add .
date=`date +%Y%m%d`
git commit -m "Auto Backuping on "$date
git push
