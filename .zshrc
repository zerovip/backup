#----------------------------------------#
# File:     .zshrc   ZSH resource file   #
# Version:  1.0                          #
# Author:   Zero                         #
#----------------------------------------#


#-----------------------------
# 0.启动语
#-----------------------------
echo -ne "Hey, handsome! Today is "; date '+%Y-%m-%d, %A'
echo -ne "Have a NICE day!"
echo -ne "\n"


#-----------------------------
# 1.插件
#-----------------------------
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
#语法高亮插件，模仿fish

if [[ -f /usr/share/autojump/autojump.zsh ]]; then
  . /usr/share/autojump/autojump.zsh
fi
#autojump插件

# if [[ -f /usr/share/zsh/plugins/incr/incr-0.2.zsh ]]; then
#   . /usr/share/zsh/plugins/incr/incr-0.2.zsh
# fi
# 暂时先不用，有点过于酸爽了
#incr插件，非使用pacman安装，于官网http://mimosa-pudica.net/zsh-incremental.html下载


#------------------------------
# 2.历史
#------------------------------
HISTFILE=~/.histfile
#历史记录文件

HISTSIZE=1000
#历史记录条目数量

SAVEHIST=1000
#注销后保存的历史记录条目数量

setopt INC_APPEND_HISTORY
#以附加的方式写入历史记录

setopt HIST_IGNORE_DUPS
#重复的不计入历史

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


#-----------------------------
# 3.习惯
#-----------------------------
alias clc='clear'
alias ls='ls -F --color=auto'
alias ll='ls -l'
alias la='ls -a'
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
alias cp='acp -g'
alias mv='amv -g'    #提前安装advcp，用来显示移动和复制的进度条

sudo-command-line() {
[[ -z $BUFFER ]] && zle up-history
[[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER" || BUFFER="${BUFFER#*sudo\ }"
zle end-of-line #光标移动到行末
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line
#双击esc行首插入/去掉sudo，oh-my-zsh中的一个有用功能
#前提是不能有bindkey -v，否则在vim模式下按一下esc就变成normal模式了
#不写bindkey，就是默认bindkey -e，即emacs模式，这时ctrl+a/e也就有效了

backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir
#使得Ctrl+w删除当前所有，而Alt+Backspace删除一个词语
#方便按Tab键备选太多时快速回退到上一个目录处


#------------------------------
# 4.颜色/主题（希望能达到dieter的效果）
#------------------------------
autoload colors
colors
#打开颜色显示


PROMPT="[%{$fg[yellow]%}%?%{$reset_color%}]%{$fg[white]%}(%*)%{$fg[magenta]%}%n@%{$fg[yellow]%}%m:%{$fg[cyan]%}%C $ "
#自定义命令提示符


#------------------------------
# 5.自动补全与错误矫正相关
#------------------------------
zstyle ':completion:*' menu select
#方向键控制选择

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
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
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


#------------------------------
# 6.小工具
#------------------------------
c() {
    local IFS=' '
    local calc="${*//p/+}"
    calc="${calc//x/*}"
    bc -l <<<"scale=10;$calc"
}
# c 开头的直接计算器


backup (){~/backup/AutoBackup.sh}
# 自动备份函数

#
#
