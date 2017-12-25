" Vundle {{{
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
"" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
"" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
"" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
"" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
"" The sparkup vim script is in a subdirectory of this repo called vim.
"" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"" Install L9 and avoid a Naming conflict if you've already installed a
"" different version somewhere else.
"Plugin 'ascenator/L9', {'name': 'newL9'}

" original repos on github<br>Bundle 'mattn/zencoding-vim'
Bundle 'drmingdrmer/xptemplate'

" 自动补全单引号，双引号等
Bundle 'Raimondi/delimitMate'

" for python docstring ", 特别有用
au FileType python let b:delimitMate_nesting_quotes = ['"']
" 关闭某些类型文件的自动补全
"au FileType mail let b:delimitMate_autoclose = 0

" vim-scripts repos
Bundle 'kien/rainbow_parentheses.vim'
let g:rbpt_colorpairs = [
    \ ['red',         'firebrick3'],
    \ ['brown',       'firebrick3'],
    \ ['brown',       'RoyalBlue3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ]
" 不加入这行, 防止黑色括号出现, 很难识别
" \ ['black',       'SeaGreen3'],
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

Bundle 'scrooloose/nerdcommenter'
" 注释的时候自动加个空格, 强迫症必配
let g:NERDSpaceDelims=1

Bundle 'bronson/vim-trailing-whitespace'
map <leader><space> :FixWhitespace<cr>

Bundle 'docunext/closetag.vim'
let g:closetag_html_style=1

Bundle 'scrooloose/nerdtree'
autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

Bundle 'terryma/vim-multiple-cursors'
let g:multi_cursor_use_default_mapping=0
" Default mapping
let g:multi_cursor_next_key='<C-m>'
let g:multi_cursor_prev_key='<C-n>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

Bundle 'tpope/vim-fugitive'

Bundle 'rkulla/pydiction'
let g:pydiction_menu_height = 20

Bundle 'yssource/python.vim'

Bundle 'kevinw/pyflakes-vim'
let g:pyflakes_use_quickfix = 0

Bundle 'Lokaltog/vim-powerline'
set laststatus=2

"Bundle 'majutsushi/tagbar'
"nmap <F8> :TagbarToggle<CR>

Bundle 'rking/ag.vim'
let g:ag_working_path_mode="r"

Bundle 'kien/ctrlp.vim'
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'
"设置过滤不进行查找的后缀名
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|pyc)$'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" latex自动补全等
Bundle 'vim-latex/vim-latex'
set shellslash
set grepprg=grep\ -nH\ $*
filetype indent on
let g:tex_flavor='latex'
set iskeyword+=:
autocmd BufEnter *.tex set sw=2

" latex实时预览工具
Bundle 'xuhdev/vim-latex-live-preview'
let g:livepreview_previewer = 'okular'
let g:livepreview_engine = 'xelatex'
autocmd Filetype tex setl updatetime=30


" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" }}}



" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim80/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

" do not load defaults if ~/.vimrc is missing
"let skip_defaults_vim=1




" Startup {{{
filetype indent plugin on
" vim 文件折叠方式为 marker
augroup ft_vim
    au!
    au FileType vim setlocal foldmethod=marker
augroup END
" }}}

" General {{{
set nocompatible
"set nobackup
"set noswapfile
set history=1024
set autochdir
set whichwrap=b,s,<,>,[,]
set nobomb
set backspace=indent,eol,start whichwrap+=<,>,[,]
" Vim 的默认寄存器和系统剪贴板共享
set clipboard+=unnamed
" 设置 alt 键不映射到菜单栏
set winaltkeys=no
" set updatetime=1000
" }}}

" Lang & Encoding {{{
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gbk2312,gbk,gb18030,ucs-bom,chinese,cp936
set encoding=utf-8
set langmenu=zh_CN
let $LANG = 'en_US.UTF-8'
language messages zh_CN.utf-8
" }}}

" GUI {{{
autocmd GUIEnter * simalt ~x
syntax enable
colorscheme desert
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set cursorline
set hlsearch
set number
" 窗口大小
"set lines=41 columns=172
" 分割出来的窗口位于当前窗口下边/右边
set splitbelow
set splitright
"不显示工具/菜单栏
set guioptions-=T
set guioptions-=m
set guioptions-=L
set guioptions-=r
set guioptions-=b
" 使用内置 tab 样式而不是 gui
set guioptions-=e
set nolist
" set listchars=tab:▶\ ,eol:¬,trail:·,extends:>,precedes:<
"set guifont=Inconsolata:h12:cANSI
set guifont=Monaco:h13:cANSI:qDRAFT
" }}}

" Format {{{
set autoindent
set smartindent
set tabstop=4
set expandtab
set softtabstop=4
set foldmethod=indent
syntax on
" }}}

" Keymap {{{
let mapleader=","

nmap <leader>s :source $VIM/_vimrc<cr>
nmap <leader>e :e $VIM/_vimrc<cr>

map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>
map <leader>th :tabp<cr>
map <leader>tl :tabn<cr>

" 移动分割窗口
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

" 正常模式下 alt+j,k,h,l 调整分割窗口大小
nnoremap <M-j> :resize +5<cr>
nnoremap <M-k> :resize -5<cr>
nnoremap <M-h> :vertical resize -5<cr>
nnoremap <M-l> :vertical resize +5<cr>

" 插入模式移动光标 alt + 方向键
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-h> <left>
inoremap <M-l> <Right>

" IDE like delete
inoremap <C-BS> <Esc>bdei

nnoremap vv ^vg_
" 转换当前行为大写
inoremap <C-u> <esc>mzgUiw`za
" 命令模式下的行首尾
cnoremap <C-a> <home>
cnoremap <C-e> <end>

nnoremap <F2> :setlocal number!<cr>
nnoremap <leader>w :set wrap!<cr>

imap <C-v> "+gP
vmap <C-c> "+y
vnoremap <BS> d
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y
imap <C-V>     "+gP
map <S-Insert>     "+gP
cmap <C-V>     <C-R>+
cmap <S-Insert>        <C-R>+

exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

" 打开当前目录 windows
map <leader>ex :!start explorer %:p:h<CR>

" 打开当前目录CMD
map <leader>cmd :!start<cr>
" 打印当前时间
map <F3> a<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>

" 复制当前文件/路径到剪贴板
nmap ,fn :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
nmap ,fp :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>

" 设置切换Buffer快捷键"
nnoremap <C-left> :bn<CR>
nnoremap <C-right> :bp<CR>

" }}}



" others {{{
set tags=tags;

set noeb

au BufRead *.py map <buffer> <F5> :w<CR>:!/usr/bin/env python % <CR>
" }}}


" backup {{{
set backup
"set backupext=.bak
"设置自动备份路径
"set backupdir=F:\download\bkup\vimbackupfile
"set patchmode=.orig
" }}}

