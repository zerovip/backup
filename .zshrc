#---------------------------------------#
# File:     ZSH resource file           #
# Version:  3.0                         #
# Author:   Zero                        #
# Date:     2025-08-15                  #
#---------------------------------------#
#                                       #
# 目录：                                #
#   1. 插件                             #
#   2. 历史                             #
#   3. 习惯                             #
#   4. 颜色/主题                        #
#   5. 自动补全与错误矫正相关           #
#   6. 小工具                           #
#                                       #
#---------------------------------------#

#---------------------------------------#
# 1.插件                                #
#---------------------------------------#

# 语法高亮插件
# 安装：zsh-fast-syntax-highlighting（AUR）
if [[ -f /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi

# Command not found 插件
# 安装：pkgfile
# 更新数据库：pkgfile -u
if [[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]]; then
    source /usr/share/doc/pkgfile/command-not-found.zsh
fi

#---------------------------------------#
# 2.历史                                #
#---------------------------------------#

# 历史记录文件
HISTFILE=~/.histfile

# 历史记录条目数量
HISTSIZE=30000

# 注销后保存的历史记录条目数量
SAVEHIST=30000

# 以附加的方式写入历史记录
setopt INC_APPEND_HISTORY

# 重复的不进行查找
setopt HIST_FIND_NO_DUPS

# 为历史记录中的命令添加时间戳
setopt EXTENDED_HISTORY

# 启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt AUTO_PUSHD

# 相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS

# 在命令前添加空格，不将此命令添加到记录文件中
setopt HIST_IGNORE_SPACE

# 匹配光标前的历史搜索
bindkey '^[[A' history-beginning-search-backward
bindkey '^[OA' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[OB' history-beginning-search-forward

#---------------------------------------#
# 3.习惯                                #
#---------------------------------------#

# Emacs 模式
bindkey -e

# 允许交互注释
setopt interactivecomments

# 常用命令缩写展开
alias sudo='sudo '  #神奇的命令，使得 sudo 操作的命令也被展开
alias ls='ls -F --color=auto'
alias ll='ls -lv'
alias la='ll -a'
alias lh='ll -h'
alias vi='vim'
alias grep="grep --color=auto"

# 双击 Esc 补上一条命令的 sudo
function sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER" || BUFFER="${BUFFER#*sudo\ }"
    zle end-of-line
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line


#---------------------------------------#
# 4.颜色/主题                           #
#---------------------------------------#

# 打开颜色显示
autoload colors
colors

# 使用 zsh-pure-prompt 主题
autoload -U promptinit; promptinit
prompt pure

#---------------------------------------#
# 5.自动补全与错误矫正相关              #
#---------------------------------------#

# 开启自动补全
autoload -U compinit
compinit

# 命令行别名自动补全
setopt COMPLETE_ALIASES

setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE

# 自动补全选项
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

# 路径补全
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'
zstyle ':completion::complete:*' '\\'

# 彩色补全菜单
eval $(dircolors -b)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# 关闭纠错功能，太愚蠢了
unsetopt correct_all

# 修正大小写
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# 错误校正
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# kill 命令补全
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

# 补全类型提示分组
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'

# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'

# jujutsu 自动补全，见文档：https://jj-vcs.github.io/jj/latest/install-and-setup/#zsh
source <(jj util completion zsh)


