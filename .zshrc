#---------------------------------------#
# File:     .zshrc   ZSH resource file  #
# Version:  2.1                         #
# Author:   Zero                        #
# Date:     2020-08-03                  #
#---------------------------------------#
#                                       #
# 目录：                                #
#   0. 启动语                           #
#   1. 插件                             #
#   2. 历史                             #
#   3. 习惯                             #
#   4. 颜色/主题                        #
#   5. 自动补全与错误矫正相关           #
#   6. 小工具                           #
#                                       #
#---------------------------------------#

#---------------------------------------#
# 0.启动语                              #
#---------------------------------------#
echo -ne "Hey, handsome! Today is "; date '+%Y-%m-%d, %A'
echo -ne "Have a NICE day!"
echo -ne "\n"


#---------------------------------------#
# 1.插件                                #
#---------------------------------------#
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
# 语法高亮插件，模仿 fish
# 直接 sudo pacman -S zsh-syntax-highlighting 安装就好

# if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
#   .  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# fi
# autosuggestion 插件，模仿 fish
# 直接 sudo pacman -S zsh-autosuggestions 安装就好
# 已卸载，就是显示一个灰色的历史记录之类的，没什么用，干扰视线
#   它显然过于不智能了，已经安装过的软件怎么可能安装第二次，已经卸载的软件怎么可能再卸载

if [[ -f /usr/share/autojump/autojump.zsh ]]; then
  . /usr/share/autojump/autojump.zsh
fi
# autojump插件
# 这是在 AUR 的包里，clone 再 makepkg -sri 就好

# if [[ -f /usr/share/zsh/plugins/incr/incr-0.2.zsh ]]; then
#   . /usr/share/zsh/plugins/incr/incr-0.2.zsh
# fi
# 暂时先不用，有点过于酸爽了
#incr插件，非使用pacman安装，于官网http://mimosa-pudica.net/zsh-incremental.html下载

if [[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
    . /usr/share/doc/pkgfile/command-not-found.zsh
fi
# 提前安装 pkgfile，这是用来解决不知道某条命令在哪个包里的问题的
# 还需要 sudo pkgfile -u 来更新 pkgfile 的数据库

# if [[ -f /usr/share/zsh/scripts/git-prompt.zsh ]]; then
#     . /usr/share/zsh/scripts/git-prompt.zsh
# fi
# 不用了，不是很有必要
# git-prompt.zsh 插件，在 AUR 的包里，先 clone 再 makepkg -sri 就好，
#   然后修改下面的命令提示符

#---------------------------------------#
# 2.历史                                #
#---------------------------------------#
HISTFILE=~/.histfile
#历史记录文件
HISTSIZE=3000
#历史记录条目数量
SAVEHIST=3000
#注销后保存的历史记录条目数量
setopt INC_APPEND_HISTORY
#以附加的方式写入历史记录
setopt HIST_FIND_NO_DUPS
#重复的不进行查找
setopt EXTENDED_HISTORY
#为历史记录中的命令添加时间戳
setopt AUTO_PUSHD
#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt PUSHD_IGNORE_DUPS
#相同的历史路径只保留一个
setopt HIST_IGNORE_SPACE
#在命令前添加空格，不将此命令添加到记录文件中
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
#显示匹配光标前的历史搜索


#---------------------------------------#
# 3.习惯                                #
#---------------------------------------#
#alias clc='clear'
alias sudo='sudo '  #神奇的命令，使得 sudo 操作的命令也被展开
alias ls='ls -F --color=auto'
alias ll='ls -l'
alias la='ll -a'
alias lh='ll -h'
alias vi='vim'
alias grep="grep --color=auto"
#alias -s py=vi    # 在命令行直接输入 python 文件，会用 vim 中打开，以下类似
#alias -s js=vi    #暂时用不到
#alias -s c=vi
#alias -s java=vi
#alias -s txt=vi
#alias -s gz='tar -xzvf'
#alias -s tgz='tar -xzvf'
#alias -s zip='unzip'
#alias -s bz2='tar -xjvf'

alias mount='mount -o gid=ehizil,uid=ehizil,fmask=113,dmask=002' # mount 后能以用户身份写入

#alias cp='acp -g'
#alias mv='amv -g'    #提前安装advcp，用来显示移动和复制的进度条

# 下面 8 行是为了使用 rsync 来使得复制的时候有进度条，
#   参考自：https://wiki.archlinux.org/index.php/Rsync#As_cp/mv_alternative
function cpr() {
  rsync --archive -hh --partial --info=stats1 --info=progress2 --modify-window=1 "$@"
} 
function mvr() {
  rsync --archive -hh --partial --info=stats1 --info=progress2 --modify-window=1 --remove-source-files "$@"
}
# alias cp='cpr'
# alias mv='mvr'
# move 好像会导致在同一个文件夹下重命名成为复制？不应该啊
# 于是干脆连复制的命令也不更改了，使用 cpr 作为带 bar 的复制好了

# alias foxit='/home/ehizil/opt/foxitsoftware/foxitreader/FoxitReader.sh &'
# 福昕阅读器

alias n='nnn -e' # 命令行式的文件管理器，-e 使得直接打开文件
# nnn 文件浏览器，类似的还有 vifm

function sudo-command-line() {
[[ -z $BUFFER ]] && zle up-history
[[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER" || BUFFER="${BUFFER#*sudo\ }"
zle end-of-line #光标移动到行末
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line
#双击esc行首插入/去掉sudo，oh-my-zsh中的一个有用功能
#前提是不能有bindkey -v，否则在vim模式下按一下esc就变成normal模式了
#不写bindkey，就是默认bindkey -e，即emacs模式，这时ctrl+a/e也就有效了

function backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir
#使得Ctrl+w删除当前所有，而Alt+Backspace删除一个词语
#方便按Tab键备选太多时快速回退到上一个目录处

#---------------------------------------#
# 4.颜色/主题                           #
#---------------------------------------#
autoload colors
colors
#打开颜色显示

#自定义命令提示符

# 下条为显示整个目录层次，家目录显示为“~”，即 %~
PROMPT="[%{$fg[yellow]%}%?%{$reset_color%}]%{$fg[white]%}(%*)%{$fg[magenta]%}%n%{$fg[yellow]%}@%m%{$fg[cyan]%}:%~ $ "

# 下条为只显示当前目录，即 %C
# PROMPT="[%{$fg[yellow]%}%?%{$reset_color%}]%{$fg[white]%}(%*)%{$fg[magenta]%}%n@%{$fg[yellow]%}%m:%{$fg[cyan]%}%C $ "

# 下条为使用插件 git-prompt.zsh 的提示符，插件已弃置不用
# PROMPT='[%{$fg[yellow]%}%?%{$reset_color%}]%{$fg[white]%}(%*)%{$reset_color%}$(gitprompt)%{$fg[cyan]%}%~ $ '

man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}
# man page 的颜色
# See, https://www.2daygeek.com/get-display-view-colored-colorized-man-pages-linux/
# 以及 notes 中对这件事的详细记录

#---------------------------------------#
# 5.自动补全与错误矫正相关              #
#---------------------------------------#
autoload -Uz compinit
compinit
#开启自动补全

setopt COMPLETE_ALIASES
#命令行别名自动补全

setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE

zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select  #方向键控制选择
zstyle ':completion:*:*:default' force-list always  #把候选项列在下面
zstyle ':completion:*' select-prompt '%SSelect: lines: %L matches: %M [%p]'
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate
#自动补全选项

zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'
zstyle ':completion::complete:*' '\\'
#路径补全

eval $(dircolors -b)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
#彩色补全菜单

unsetopt correct_all
#关闭纠错功能，太愚蠢了

# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#修正大小写

# zstyle ':completion:*' completer _complete _match _approximate
# zstyle ':completion:*:match:*' original only
# zstyle ':completion:*:approximate:*' max-errors 1 numeric
#错误校正

compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'
#kill 命令补全

zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'
#补全类型提示分组

zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
# cd ~ 补全顺序


#---------------------------------------#
# 6.小工具                              #
#---------------------------------------#
# c() {
#     local IFS=' '
#     local calc="${*//p/+}"
#     calc="${calc//x/*}"
#     bc -l <<<"scale=10;$calc"
# }
# c 开头的直接计算器
# 因为没有安装 bc，觉得平时使用也不多，就不用了.

backup (){~/backup/AutoBackup.sh}
# 自动备份函数

#
#
