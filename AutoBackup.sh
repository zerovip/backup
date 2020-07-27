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
cp -r /usr/share/grub/themes/allurez/ ~/backup/backup/

# 确保 .bin（自己写的程序的地方） 自动加载到环境变量中
# 暂时还没有任何自己的程序
cp ~/.zprofile ~/backup/backup/

# .xprofile 这里是本地中文化、桌面壁纸以及 ibus 输入法的一些自动启动项
cp ~/.xprofile ~/backup/backup/

# .xinitrc 应该没有做过任何改动，但以防万一还是备份一下
# 不再需要了
# cp ~/.xinitrc ~/backup/backup/

# 所有自己写的程序存放处
# 暂时还没有，先不用备份
# cp -r ~/.bin/ ~/backup/backup/

# 应用在 plasma 的右击菜单中的自定义选项
# 暂时还没有，先不用备份
# cp -r ~/.local/share/kservices5/ ~/backup/backup/

# bspwm 一个平铺窗口管理器的配置备份
cp ~/.config/bspwm/bspwmrc ~/backup/backup/

# bspwm 需要的监听键盘输入的 sxhkd 的配置备份
cp ~/.config/sxhkd/sxhkdrc ~/backup/backup/

# alacritty 一个新终端模拟器的配置文件，替代 xterm
cp ~/.config/alacritty/alacritty.yml ~/backup/backup/

# ctags 软件的额外配置文件（以便识别 latex 中的 \ref 和 \label）备份
# 暂时还没有，先不备份
# cp ~/.ctags ~/backup/backup/

# Xsource 的配置文件，主要是对 Xterm 进行了配置
# 谁能想到，我现在不用 Xterm 了，改用 urxvt 了，但还是在这里设置
# 谁能想到，因为中文字体间距的问题，我又用回 Xterm 了.
# 谁能想到，因为 Unicode 符号的一些问题，我又转移阵营到 alacritty 了.
cp ~/.Xresources ~/backup/backup/

# 字体渲染的配置
cp ~/.config/fontconfig/fonts.conf ~/backup/backup/

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
# 这次并没有成功解决这个问题，暂时也算了
# cp ~/.mozilla/firefox/3cky76on.default/chrome/userChrome.css ~/backup/backup/

# 配置文件同步到 GitHub
cd ~/backup/backup
echo ""
echo ""
echo "==================================="
echo "下面是配置文件的备份"
# 这条判断语句参考自：https://stackoverflow.com/a/25149786/9783145
if [[ `git status --porcelain --untracked-files=no` ]]; then
    git add .
    date=`date +%Y%m%d`
    git commit -m "Auto Backuping on "$date
    git push
    echo "配置文件有一些变化，已经备份成功！"
else
    echo "配置文件没有变化，无需备份！"
fi

# 数学区文件同步到 GitHub
cd ~/math-works
echo ""
echo ""
echo "==================================="
echo "下面是数学工作的备份(private)"
if [[ `git status --porcelain --untracked-files=no` ]]; then
    read -p "数学工作区有哪些更改：" ma_mesg
    git add .
    git commit -m "$ma_mesg"" Auto Backuping on "$date
    git push
    echo "数学工作有一些变化，已经备份成功"
else
    echo "数学工作没有变化，无需备份！"
fi

# 博客push
# 在配置博客的时候要注意，要把 public 文件夹删掉
#   然后从 zerovip.github.io 这个仓库克隆到 public
#   然后把这个 public 里面的文件都删掉，再 deploy
#   即，再生成，再上传，这样才能把 public 文件夹作为
#   子模组，并且直接推到 GitHub Pages.
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
if [[ `git status --porcelain --untracked-files=no` ]]; then
    read -p "博客有哪些变化：" po_mesg
    git add .
    git commit -m "$po_mesg"" Auto pushing blog on "$date
    git push
    echo "博客原始文件有些变化，已经备份成功！"
else
    echo "博客原始文件没有变化，无需备份！"
fi

# 博客主题 push
cd ~/codes/blog/themes/zero
echo ""
echo ""
echo "==================================="
echo "下面是博客主题的备份"
if [[ `git status --porcelain --untracked-files=no` ]]; then
    read -p "博客主题有哪些更改：" po_th_mesg
    git add .
    git commit -m "$po_th_mesg"" Auto pushing blog on "$date
    git push
    echo "博客主题有些变化，已经备份成功！"
else
    echo "博客主题没有变化，无需备份！"
fi

