#!/bin/sh

# zsh 配置备份
cp ~/.zshrc ~/backup/backup/

# vim 配置备份
cp ~/.vimrc ~/backup/backup/

# 笔记备份
cp ~/notes ~/backup/backup/

# 本自动同步程序备份
cp ~/backup/AutoBackup.sh ~/backup/backup/

# fstab 开机挂载硬盘备份
cp /etc/fstab ~/backup/backup/

# 输入法 ibus + rime 配置备份
cp ~/.config/ibus/rime/default.custom.yaml ~/backup/backup/

# 开机 GRUB 页面自己制作的主题备份
cp -r /boot/grub/themes/allurez/ ~/backup/backup/

# 确保 .bin（自己写的程序的地方） 自动加载到环境变量中
cp ~/.zprofile ~/backup/backup/

# .xprofile 这里是 ibus 输入法的一些自动启动项吧
cp ~/.xprofile ~/backup/backup/

# .xinitrc 应该没有做过任何改动，但以防万一还是备份一下
cp ~/.xinitrc ~/backup/backup/

# 所有自己写的程序存放处
cp -r ~/.bin/ ~/backup/backup/

# 应用在 plasma 的右击菜单中的自定义选项
cp -r ~/.local/share/kservices5/ ~/backup/backup/

# bspwm 一个平铺窗口管理器的配置备份
cp ~/.config/bspwm/bspwmrc ~/backup/backup/

# bspwm 需要的监听键盘输入的 sxhkd 的配置备份
cp ~/.config/sxhkd/sxhkdrc ~/backup/backup/

# ctags 软件的额外配置文件（以便识别 latex 中的 \ref 和 \label）备份
cp ~/.ctags ~/backup/backup/

# Xsource 的配置文件，主要是对 Xterm 进行了配置
cp ~/.Xresources ~/backup/backup/

# vim 的 snippet 们
cp -r ~/codes/UltiSnips/ ~/backup/backup/

# 博客脚本备份
cp ~/codes/deploy.sh ~/backup/backup/

# 关于手机通过数据线共享无线网的配置备份
###  cp /etc/udev/rules.d/90-android-tethering.rules ~/backup/backup/
###  cp /etc/systemd/network/50-enp0s20u2.network ~/backup/backup/

# 所有已安装软件
pacman -Qeq | sort > ~/backup/backup/alpkglist

# 所有 AUR 中安装的软件
pacman -Qmq | sort > ~/backup/backup/otpkglist

# 所有官方库中安装的软件
comm -23 ~/backup/backup/alpkglist ~/backup/backup/otpkglist > ~/backup/backup/pkglist

# Firefox浏览器 “Tree Style Tab” 插件后顶栏重复显示的问题解决文件备份
cp ~/.mozilla/firefox/3cky76on.default/chrome/userChrome.css ~/backup/backup/

# 配置文件同步到 GitHub
cd ~/backup/backup
echo ""
echo ""
echo "==================================="
echo "下面是配置文件的备份"
git add .
date=`date +%Y%m%d`
git commit -m "Auto Backuping on "$date
git push

# 数学区文件同步到 GitHub
cd ~/math-works
echo ""
echo ""
echo "==================================="
echo "下面是数学工作的备份(private)"
git add .
git commit -m "Auto Backuping on "$date
git push

# 博客主题 push
cd ~/codes/blog/themes/zero
echo ""
echo ""
echo "==================================="
echo "下面是博客主题的备份"
git add .
git commit -m "Auto pushing blog on "$date
git push

# 博客push
echo ""
echo ""
echo "==================================="
echo "下面是博客的自动部署脚本"
~/codes/deploy.sh "auto pushing..."
cd ~/codes/blog
echo ""
echo ""
echo "==================================="
echo "下面是博客原始文件夹的备份(private)"
git add .
git commit -m "Auto pushing blog on "$date
git push
