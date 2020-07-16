"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Notes:
"       Everything changes fast. Two years ago, I spent lots of time
"   configuring my .vimrc file, hoping it can last forever and I will
"   never need to worry about it. Well, two years passed, Bundle is
"   decaying, vim-plug took its place.
"
"       I realized that it is impossible to always follow the latest
"   fashion, maybe just using the most popular things is the simple
"   and safe way, especially for me, the person who has more important
"   things to do.
"
"       So now, let me update my vim configuration again, and this time
"   I will use the the repo with most stars in GitHub right now:
"
"       https://github.com/amix/vimrc
"
"       Hope everthing works well.
"
"                                               Zero
"                                            2020.07.10
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Original_author: 
"       Amir Salihefendic — @amix3k
"
" Awesome_version:
"       Get this config, nice color schemes and lots of plugins!
"
"       Install the awesome version from:
"
"           https://github.com/amix/vimrc
"
" Edit:
"       Zero
"
" Sections:
"    -> Plugins
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"     ==> Install part
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

" 1. lightline
" for the bottom status line
" Similar tools:
"   airline, see, https://github.com/vim-airline/vim-airline
" See, https://github.com/itchyny/lightline.vim
Plug 'itchyny/lightline.vim'

" 2. Rainbow Parentheses
" For colorful brackets
" Similar tool:
"   rainbow, see, https://github.com/luochen1990/rainbow
" See, https://github.com/kien/rainbow_parentheses.vim
Plug 'kien/rainbow_parentheses.vim'

" 3. gruvbox
" a theme
" See, https://github.com/morhetz/gruvbox/wiki/Installation
Plug 'morhetz/gruvbox'

" 4. pear-tree
" auto close quotes, HTML tags, brackets, and so on
" See, https://github.com/tmsvg/pear-tree
" To replace auto-pair, https://github.com/jiangmiao/auto-pairs
Plug 'tmsvg/pear-tree'

" 5. multiple-cursors
" multiple cursors operating tool
" See, https://github.com/terryma/vim-multiple-cursors
Plug 'terryma/vim-multiple-cursors'

" 6. vimtex
" for LaTeX helper
" See, https://github.com/lervag/vimtex
Plug 'lervag/vimtex'

" 7. UltiSnips
" basicly for LaTeX file and MarkDown blog file
" See, https://github.com/SirVer/ultisnips
Plug 'SirVer/ultisnips'

" 8. vim-commentary
" simple tool to comment one line
" See, https://github.com/tpope/vim-commentary
Plug 'tpope/vim-commentary'

" 9. indentLine
" for displaying thin vertical lines at each indentation level
"   for code indented with spaces.
" See, https://github.com/wsdjeg/indentLine
Plug 'wsdjeg/indentLine'

" 10. bufferline
" Super simple vim plugin to show the list of buffers in the command bar.
" See, https://github.com/bling/vim-bufferline
Plug 'bling/vim-bufferline'

call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"     ==> Configure part
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 1. lightline
" 被动工具
" 让 lightline 显示出来
set laststatus=2
" 重写 filename 部分，改为 cwd，把路径显示出来
" 加入 bufferline 部分，在 statusline 中显示 buffer 信息
"   参考：https://github.com/itchyny/lightline.vim/issues/36
" 写自己的 vimscript，条件语句比较见：
"   https://www.w3cschool.cn/vim/sdiuyozt.html
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'bufferline' ],
      \             [ 'readonly', 'cwd', 'modified' ] ],
	  \   'right': [ [ 'paste', 'mode' ],
	  \            [ 'percent', 'lineinfo' ],
      \            [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component': {
      \   'cwd': ' %F ',
      \   'bufferline': '%{bufferline#refresh_status()}'.
      \                 '%{MyBufferline()[0]}'.
      \                 '%{MyBufferline()[1]}'.
      \                 '%9*%{g:bufferline_status_info.current}'.
      \                 '%{MyBufferline()[2]}'
      \ },
        \ 'component_function': {
        \   'fileformat': 'LightlineFileformat',
        \   'filetype': 'LightlineFiletype',
        \ },
      \ }
" colorscheme 能写 gruvbox 是建立在安装了 gruvbox 插件的基础上的，
"   而 gruvbox 兼容了 lightline
function! MyBufferline()
  call bufferline#refresh_status()
  let b = g:bufferline_status_info.before
  let c = g:bufferline_status_info.current
  let a = g:bufferline_status_info.after
  let alen = strlen(a)
  let blen = strlen(b)
  let clen = strlen(c)
  let w = winwidth(0) * 4 / 9
  if w < alen+blen+clen+8
    let aa = a ==# "" ? a : '...'
    let bb = b ==# "" ? b : '...'
    let bf = aa ==# "" && bb ==# "" ?  "Buffer:  " : "Buffers: "
    return [bf, bb, aa]
  else
    let bf = a ==# "" && b ==# "" ? "Buffer:  " : "Buffers: "
    return [bf, b, a]
  endif
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

" 2. Rainbow Parentheses
" 被动工具
" 括号颜色列表
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['brown',       'firebrick3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
" 自动开启
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" 3. gruvbox
" 被动工具
" See, https://github.com/morhetz/gruvbox/wiki/Configuration
" and, https://github.com/morhetz/gruvbox/wiki/Usage
colorscheme gruvbox
" 使用下面的一行，等其他所有插件都加载完了再加载这个 gruvbox，
"   会引起报错，因为在上面 lightline 里面指定了 gruvbox 主题，
"   只能用上面的一条，直接指定主题. 关于 autocmd 还需要学习
"autocmd vimenter * colorscheme gruvbox
set background=dark

" 4. pear-tree
" 基本是被动工具，但也可以自己加一些或删一些配对

" 5. multiple-cursors
" 主动工具，需要学习一下，gvim 可能会遇到一个问题

" 6. vimtex
" 基本是被动工具
" 确保总能正确识别latex文件
let g:tex_flavor='latex'
" 确保有 clientsever 功能以便提供 feedback
if empty(v:servername) && exists('*remote_startserver')
    call remote_startserver('VIM')
endif
" 指定预览使用 zathura
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
" 指定编译器，不过这里 latexmk 也就是默认的
let g:vimtex_compiler_method='latexmk'
" 关于编译引擎，要写在文件里 %! TEX program = program

" 7. UltiSnips
" 主动工具
" 该程序需要 vim 对 python 的支持，可2可3，一般不写，这里写出来明确用3
let g:UltiSnipsUsePythonVersion = 3
" 模板片段【搜寻处】，默认就是下面这只有一个元素的列表，用的时候是在这里找
let g:UltiSnipsSnippetDirectories=[$HOME.'/codes/UltiSnips', $HOME.'/codes/current_course']
" tab 键和另一个插件冲突。Trigger configuration. Do not use <tab> if
" you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<C-tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" 8. vim-commentary
" 主动工具

" 9. indentLine
" 被动工具

" 10. bufferline
" 被动工具
" 不在命令行窗口显示，而是在 lightline 里调用
let g:bufferline_echo=0
" 更改左右标识
let g:bufferline_active_buffer_left=' ►'
let g:bufferline_active_buffer_right='◄ '
"   保证总字符数一样多，都是 2 个，和下面的 separator 一样多
"   特殊符号列表见：http://www.weisuyun.com/BQ/BQ.html
" 非选中项的左右两端填充的字符，
"   这是在文档中找不到的参数，是我看源码看到的，
"   见：https://github.com/bling/vim-bufferline/blob/master/plugin/bufferline.vim#L14
let g:bufferline_separator='  '
"   separator 和上面的 buffer_left/right 字符数一样多，
"   这样在切换 buffer 时就不会左右乱跑

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use mouse in xterm
set mouse=a

" Sets how many lines of history VIM has to remember
set history=2000

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
" let mapleader = ","
" I prefer using the default \ key

" Fast saving in normal mode
nmap <leader>w :w!<cr>
" Fast saving in insert mode
inoremap <F3> <C-o>:w<CR>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 高亮光标所在的行
set cursorline

" 去掉下面的插入模式显示
set noshowmode

" 设置行号
set number

" Set the maximal lines warning
set colorcolumn=80

" Set 7 lines to the cursor - when moving vertically using j/k
" 提前翻页，保持总能在屏幕中看到光标上下 7 行的内容
set so=7

" Avoid garbled characters in Chinese language windows OS
" 暂时还不明白 menu 是什么，有什么用
let $LANG='en' 
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the Wild menu
" Vim 中冒号（:）开头的命令进行增强补全，按 Tab 键触发
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

"Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
" 可以删除 eol 字符: 在行开头用退格键合并两行
" 可以删除 start 字符: 可以删除之前保存过的、非此次编辑的字符
" 可以删除 indent 字符：如果有自动缩进，自动的缩进是可以删掉的
set backspace=eol,start,indent
" whichwrap 设置：下一行的第一个字符与上一行的最后一个字符的允许跳转
" b: 在 Normal 或 Visual 模式下按删除(Backspace)键
" s: 在 Normal 或 Visual 模式下按空格键
" h: 在 Normal 或 Visual 模式下按 h 键
" l: 在 Normal 或 Visual 模式下按 l 键
" <: 在 Normal 或 Visual 模式下按左方向键
" >: 在 Normal 或 Visual 模式下按右方向键
" ~: 在 Normal 模式下按 ~ 键(翻转当前字母大小写)
" [: 在 Insert 或 Replace 模式下按左方向键
" ]: 在 Insert 或 Replace 模式下按右方向键
set whichwrap+=<,>,h,l

" Ignore case when searching
" 搜索时对大小写不敏感
set ignorecase

" When searching try to be smart about cases
" 在对大小写不敏感的情况下智能地抑制这一点
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
" 搜索的及时预览
set incsearch 

" Don't redraw while executing macros (good performance config)
" macros 是宏的意思，暂时不太懂
set lazyredraw 

" For regular expressions turn magic on
" 关于正则表达式，还需要系统地学习一次
set magic

" Show matching brackets when text indicator is over them
set showmatch 
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" Add a bit extra margin to the left
set foldcolumn=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable 

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" not use desert theme any more, use gruvbox instead.
"   See, the plugins section at the head of this file.
" try
"     colorscheme desert
" catch
" endtry

" set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and zh_CN as the standard language
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gbk2312,gbk,gb18030,ucs-bom,chinese,cp936
set encoding=utf-8
set langmenu=zh_CN
let $LANG = 'en_US.UTF-8'
language messages zh_CN.utf-8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <C-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
" 还需要好好学习一下 buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
" 还需要好好学习一下 buffer
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
" 还需要好好学习一下 tab
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Use lightline plugin instead, 
"   see the Plugin section at the begining of this file.

" Always show the status line
" set laststatus=2

" Format the status line
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
