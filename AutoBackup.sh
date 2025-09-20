#!/bin/sh

# zsh 配置备份
cp ~/.zshrc ~/Backups/backup/

# vim 配置备份
cp ~/.vimrc ~/Backups/backup/
# 更改 Hugo 中 front-matter 部分的高亮按照 markdown 进行而非 yaml 进行的问题
cp ~/.vim/after/syntax/markdown.vim ~/Backups/backup/
# vim 的 snippet 们
cp -r ~/.vim/UltiSnips/ ~/Backups/backup/

# fstab 开机挂载硬盘备份
cp /etc/fstab ~/Backups/backup/

# iwd 网络配置
cp -r /etc/iwd/ ~/Backups/backup/

# yazi 配置
cp -r ~/.config/yazi/ ~/Backups/backup/

# 输入法 fcitx5 配置备份
cp -r ~/.config/fcitx5/ ~/Backups/backup/

# Aegisub 的 lua 脚本备份
# cp -r ~/.aegisub/automation/autoload/ ~/Backups/backup/

# .profile 这里是环境变量
cp ~/.profile ~/Backups/backup/

# 所有自己写的程序存放处
cp -r ~/.bin/ ~/Backups/backup/
# 不要放 noedb_token
rm -f ~/Backups/backup/.bin/neodb_token

# niri 一个滚动式平铺窗口管理器的配置备份
cp -r ~/.config/niri/ ~/Backups/backup/

# alacritty 一个新终端模拟器的配置文件，替代 xterm
cp ~/.config/alacritty/alacritty.toml ~/Backups/backup/

# 字体渲染的配置
cp ~/.config/fontconfig/fonts.conf ~/Backups/backup/

# waybar 配置备份
cp -r ~/.config/waybar/ ~/Backups/backup/

# VNote 主题备份
cp -r ~/.local/share/VNote/VNote/themes/vscode-dark-zero/ ~/Backups/backup/

# 博客脚本备份
cp ~/Blogs/deploy.sh ~/Backups/backup/

# 所有已安装软件
pacman -Qeq | sort > ~/Backups/backup/alpkglist

# 所有 AUR 中安装的软件
pacman -Qmq | sort > ~/Backups/backup/otpkglist

# 所有官方库中安装的软件
comm -23 ~/Backups/backup/alpkglist ~/Backups/backup/otpkglist > ~/Backups/backup/pkglist

# 配置文件同步到 GitHub
cd ~/Backups/backup
echo ""
echo "========================================================================="
echo ""
echo "下面是配置文件的备份"
# 这条判断语句参考自：https://stackoverflow.com/a/25149786/9783145
if [[ `git status --porcelain --untracked-files=no` ]]; then
    git add .
    date=`date +%Y%m%d`
    git commit -m "Auto Backuping on "$date
    git push
    echo "配置文件有一些变化，已经备份成功！"
elif check_git | grep -q 'Need to push'; then
    git push origin master
    cd ..
    echo "之前的提交没有推上，现在搞定！"
else
    echo "配置文件没有变化，无需备份！"
fi

# 豆瓣和 mastodon 同步到 GitHub 私人仓库
cd ~/Backups/archive
echo ""
echo "========================================================================="
echo ""
echo "下面是豆瓣、Mastodon 等文件的备份"
if [[ `git status --porcelain --untracked-files=no` ]]; then
    git add .
    date=`date +%Y%m%d`
    git commit -m "Auto Backuping on "$date
    git push
    echo "豆瓣、Mastodon 备份文件有一些变化，已经备份成功！"
elif check_git | grep -q 'Need to push'; then
    git push origin master
    cd ..
    echo "之前的提交没有推上，现在搞定！"
else
    echo "豆瓣、Mastodon 备份文件没有变化，无需备份！"
fi

# 博客push
# 在配置博客的时候要注意，要把 public 文件夹删掉
#   然后从 zerovip.github.io 这个仓库克隆到 public
#   然后把这个 public 里面的文件都删掉，再 deploy
#   即，再生成，再上传，这样才能把 public 文件夹作为
#   子模组，并且直接推到 GitHub Pages.
# echo ""
# echo "========================================================================="
# echo ""
# echo "下面是博客的自动部署脚本"
# ~/codes/deploy.sh "auto pushing..."
# cd ~/codes/blog
# echo ""
# echo "========================================================================="
# echo ""
# echo "下面是博客原始文件夹的备份(private)"
# if [[ `git status --porcelain --untracked-files=no` ]]; then
#     read -p "博客有哪些变化：" po_mesg
#     git add .
#     git commit -m "$po_mesg"" Auto pushing blog on "$date
#     git push
#     echo "博客原始文件有些变化，已经备份成功！"
# elif check_git | grep -q 'Need to push'; then
#     git push origin master
#     cd ..
#     echo "之前的提交没有推上，现在搞定！"
# else
#     echo "博客原始文件没有变化，无需备份！"
# fi
# rm -rf ~/codes/blog/public/*

# 博客主题 push
# cd ~/codes/blog/themes/zero
# echo ""
# echo "========================================================================="
# echo ""
# echo "下面是博客主题的备份"
# if [[ `git status --porcelain --untracked-files=no` ]]; then
#     read -p "博客主题有哪些更改：" po_th_mesg
#     git add .
#     git commit -m "$po_th_mesg"
#     git push
#     echo "博客主题有些变化，已经备份成功！"
# elif check_git | grep -q 'Need to push'; then
#     git push origin master
#     cd ..
#     echo "之前的提交没有推上，现在搞定！"
# else
#     echo "博客主题没有变化，无需备份！"
# fi

