"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Notes:
"
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
"
"       I learned about the vim 8.0 build-in package managementing way,
"   it is cool, but seems not convenient as vim-plug. So, I will for now
"   adhere to vim-plug.
"
"                                            2020.07.18
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Original_author: 
"       Amir Salihefendic — @amix3k
"       https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
"
" Last_commit:
"       2019-11-30
"
" Edit:
"       by Zero
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins (Using vim-plug to manage.)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', {'as': 'dracula'}
Plug 'itchyny/lightline.vim'
Plug 'luochen1990/rainbow'
Plug 'tmsvg/pear-tree'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'SirVer/ultisnips', {'for': ['tex', 'markdown', 'javascript']}
Plug 'tpope/vim-commentary'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'bling/vim-bufferline'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'junegunn/vim-easy-align'
Plug 'skywind3000/asyncrun.vim', {'on': ['AsyncRun', 'AsyncStop'] }
Plug 'skywind3000/asynctasks.vim', {'on': ['AsyncTask', 'AsyncTaskMacro', 'AsyncTaskList', 'AsyncTaskEdit'] }
Plug 'vim-scripts/BufOnly.vim'

call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 0. gruvbox
" a theme
" See, https://github.com/morhetz/gruvbox/wiki/Installation
" 被动工具
" See, https://github.com/morhetz/gruvbox/wiki/Configuration
" and, https://github.com/morhetz/gruvbox/wiki/Usage
"----------------------------------------------------------
colorscheme gruvbox
" 使用下面的一行，也就是 gruvbox 官方 wiki 里的语句，
"   等其他所有插件都加载完了再加载这个 gruvbox，
"   会导致 lightline 里自己定义的 buffer 颜色失效
"   所以只能用上面的一条，直接指定主题. 关于 autocmd 还需要学习
" autocmd vimenter * ++nested colorscheme gruvbox

set background=dark

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 0.5. dracula
" another theme
" 被动工具
" For the theme project, see https://draculatheme.com/
" For vim theme, see https://draculatheme.com/vim
" Its github: https://github.com/dracula/vim/
"----------------------------------------------------------
" 完全不在设置中使用，只是在 .zshrc 中判断一下，把 vim 用 alias
"   给它设置一个别名，alias vim='vim -c \"colorscheme dracula\"'
"   让在特定情况下（即在 scratchpad 里）vim 打开后执行这一个指令，
"   保持 scratchpad 里 vim 的主题与 alacritty 主题一致

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 1. lightline
" for the bottom status line
" Similar tools:
"   airline, see, https://github.com/vim-airline/vim-airline
" See, https://github.com/itchyny/lightline.vim
" 被动工具
"----------------------------------------------------------
" 让 lightline 显示出来
set laststatus=2

" 重写 filename 部分，改为 full_path，把路径显示出来
" 加入 bufferline 部分，在 statusline 中显示 buffer 信息
"   参考：https://github.com/itchyny/lightline.vim/issues/36
" 写自己的 vimscript，条件语句比较见：
"   https://www.w3cschool.cn/vim/sdiuyozt.html
" syntax enable
"   syntax enable 应该在定义自己的颜色之前声明，
"       否则自己定义的颜色会被这条语句清除——（没有查，是我实验出来的结果）
"   当然这里不写也没问题，因为 vim-plug 自动帮我们写好了
"       见：https://github.com/junegunn/vim-plug/issues/379
highlight User1 ctermfg=255 ctermbg=240
highlight User2 cterm=bold ctermfg=236 ctermbg=228
highlight User3 ctermfg=248 ctermbg=240
" 写三个自己的颜色，
"   User1 用在 Buffer 字符串，User2 用在选中的 buffer，User3 用在未选中的 buffer
"   使用 User1 的方式是 %1*，使用 User2 的方式是 %2*，有名字的颜色组的使用
"       方式是 %#color-Group-Name#，具体有那些颜色直接用 :hi 就能看到
"   hi 是 highlight 的简写，h 是 help 的简写，用哪个都可以
"   见 vim 的帮助文档，:h statusline，:h highlight
" 这里可以用的变量有：  guifg: gui 模式下的前景，可以用十六进制颜色码
"                       guibg：gui 模式下的背景，ditto
"                       ctermfg / ctermbg：彩色终端下的，可以用 256 颜色码
"                       term：黑白终端下的，可以用，bold，underline，standout之类的
"   其中，十六进制颜色码就是 #rrggbb 颜色，每两位用一个十六进制数表示
"       256 颜色码见，https://github.com/guns/xterm-color-table.vim
"           或，http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
"   我这里是 xterm 终端模拟器，最多 256 个颜色，所以写 cterm 项就好

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'bufferline' ] ],
      \   'right': [ [ 'percent', 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ],
      \              [ 'modified', 'full_path', 'readonly' ] ]
      \ },
      \ 'component': {
      \   'full_path': ' %<%F ',
      \   'bufferline': '%1*%{bufferline#refresh_status()}'.
      \                 '%{MyBufferline()[0]}'.
      \                 '%3*%{MyBufferline()[1]}'.
      \                 '%2*%{g:bufferline_status_info.current}'.
      \                 '%3*%{MyBufferline()[2]}'
      \ },
        \ 'component_function': {
        \   'fileformat': 'LightlineFileformat',
        \   'filetype': 'LightlineFiletype',
        \ },
      \ }
" colorscheme 能写 gruvbox 是建立在安装了 gruvbox 插件的基础上的，
"   而 gruvbox 兼容了 lightline
" 最后没有选择 gruvbox，而是用了 wombat，这是因为这个主题的左边二级颜色不变，
"   方便我写自己的 buffer 部分

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
    let bf = w < 40 ? "" : aa ==# "" && bb ==# "" ?  "Buffer:  " : "Buffers: "
    return [bf, bb, aa]
  else
    let bf = w < 40 ? "" : a ==# "" && b ==# "" ? "Buffer:  " : "Buffers: "
    return [bf, b, a]
  endif
endfunction
" statusline 中的这个 bufferline 还是花费了我大量心血的，这里面需要注意的点有：
"   1. wombat 是一个合适的主题，它合适就合适在左边的第二级不会随着模式的改变
"       发生颜色的变化，于是 Buffer 的背景色直接用这个颜色就好，如果不一样的话，
"       字符串 “Buffer” 的左边有一个第二级颜色的小小的空格
"   2. 注意折断逻辑：当窗口越来越小时，折断的顺序是：
"       a. current_path，这是通过 vim script 中的“<”符号进行的，很智能，
"           后面如果其他东西折断掉了有了空余位置，它还会补充回来
"       b. 字符串 “Buffer” 消失，这是上面的函数做了判断的
"       c. 下面两个函数定义的两个 fileformat 和 filetype 消失
"       d. 前后的未选中的 buffer 变为省略号，这是上面函数做判断的结果
"   3. 注意那些简写的判断语句，语法是：
"       let x = 判断语句 ? 判断成功的赋值 : 判断失败的赋值
"           其中判断失败处可以再写一个这样的判断语句
"       很高效

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 2. Rainbow
" For colorful brackets
" See, https://github.com/luochen1990/rainbow
"   Similar tool:
" Rainbow Parenthesessee, https://github.com/kien/rainbow_parentheses.vim
" 被动工具
"----------------------------------------------------------
" 自动开启
let g:rainbow_active=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 3. pear-tree
" auto close quotes, HTML tags, brackets, and so on
" See, https://github.com/tmsvg/pear-tree
" To replace auto-pair, https://github.com/jiangmiao/auto-pairs
" 基本是被动工具，但也可以自己加一些或删一些配对
"----------------------------------------------------------
" 不要自动隐藏闭合符号，宁愿不要 . 命令重复的特性
let g:pear_tree_repeatable_expand=0

" 智能括号模式要手动打开
" let g:pear_tree_smart_openers=1
" 这个智能开始符号不开启，不然有时会和后面的匹配导致同一行的都匹配不上
let g:pear_tree_smart_closers=1
let g:pear_tree_smart_backspace=1

" 在非引号的成对符号内部使用空格时自动添加空格
imap <Space> <Plug>(PearTreeSpace)

" 使用 shift + tab 键跳出括号环境
imap <C-j> <Plug>(PearTreeJump)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 4. vim-visual-multi
" multiple cursors operating tool
" See, https://github.com/mg979/vim-visual-multi,
"   To replace multiple-cursors
" 主动工具，还需要学习
"   学习方法也简单，它自带了教程
"   执行 vim -Nu ~/.vim/plugged/vim-visual-multi/tutorialrc 即可

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 5. vimtex
" for LaTeX helper
" See, https://github.com/lervag/vimtex
" 基本是被动工具
"----------------------------------------------------------
" 确保总能正确识别latex文件
let g:tex_flavor='latex'

" 确保有 clientsever 功能以便提供 feedback
if empty(v:servername) && exists('*remote_startserver')
    call remote_startserver('VIM')
endif

" 指定预览使用 zathura
let g:vimtex_view_method='zathura'

" quickfix 就是报错信息
let g:vimtex_quickfix_mode=0

" 指定编译器，不过这里 latexmk 也就是默认的
let g:vimtex_compiler_method='latexmk'
" 关于编译引擎，要写在文件里 %! TEX program = program

" 不要自动缩进
let g:vimtex_indent_enabled=0

" 自动补全相关：
"   自动补全引用. 只要已经编译过了，\ref{<C-x><C-o>} 即可唤出
"   其他的环境之类的，基本上都是 <C-x><C-o> 可唤出

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 6. UltiSnips
" basicly for LaTeX file and MarkDown blog file
" See, https://github.com/SirVer/ultisnips
" 主动工具
"----------------------------------------------------------
" 该程序需要 vim 对 python 的支持，可2可3，一般不写，这里写出来明确用3
let g:UltiSnipsUsePythonVersion=3

" 模板片段【搜寻处】，默认就是下面这只有一个元素的列表，用的时候是在这里找
let g:UltiSnipsSnippetDirectories=[$HOME.'/codes/UltiSnips', $HOME.'/codes/current_course']

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-l>"
let g:UltiSnipsListSnippets="<C-h>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 7. vim-commentary
" simple tool to comment one line
" See, https://github.com/tpope/vim-commentary
" 主动工具

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 8. Indent Guides
" for visually displaying indent levels in Vim.
" See, https://github.com/nathanaelkane/vim-indent-guides
" Similar tool: indentLine
" 被动工具
"----------------------------------------------------------
" 自动启动
let g:indent_guides_enable_on_vim_startup=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 9. bufferline
" Super simple vim plugin to show the list of buffers in the command bar.
" See, https://github.com/bling/vim-bufferline
" 被动工具
"----------------------------------------------------------
" 不在命令行窗口显示，而是在 lightline 里调用
let g:bufferline_echo=0

" 更改左右标识
" let g:bufferline_active_buffer_left='|'
" let g:bufferline_active_buffer_right='|'
"   保证总字符数一样多，都是 1 个，和下面的 separator 一样多
"   特殊符号列表见：http://www.weisuyun.com/BQ/BQ.html
" 最后决定还是不改了，默认的中括号就挺好

" 非选中的左右两边进行填充
" 文档中没有写，源码里有
" 见， https://github.com/bling/vim-bufferline/blob/master/plugin/bufferline.vim#L14
let g:bufferline_separator='|'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 10. vim-lsp, vim-lsp-settings, asyncomplete.vim, asyncomplete-lsp.vim
" vim-lsp: language server protocal support,
" vim-lsp-settings: auto configurations for Language Server for vim-lsp
" asyncomplete.vim: async completion
" asyncomplete-lsp.vim: cooperate with vim-lsp
" See, https://github.com/prabirshrestha/vim-lsp
"       https://github.com/mattn/vim-lsp-settings
"       https://github.com/prabirshrestha/asyncomplete.vim
"       https://github.com/prabirshrestha/asyncomplete-lsp.vim
" 基本上是一个被动工具，但需要前期配置很多，每一个语言也需要安装服务器
"----------------------------------------------------------
" Tab completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 11. vim-easy-align
" for alignment
" See, https://github.com/junegunn/vim-easy-align
" 主动工具，以后要好好学习 
"----------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" 录制几个宏，方便在 markdown 表格里对齐
let @c = "vipga*|"  " 中间对齐
let @l = "vipga*|"      " 左对齐
let @r = "vipga*|"    " 右对齐

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 12. asynctasks.vim（依赖 asyncrun.vim）
" to handle building/running/testing/deploying tasks
" See, https://github.com/skywind3000/asynctasks.vim
" 主动工具，但应该比较简单，主要是做自动运行、编译代码这种工作
"----------------------------------------------------------
let g:asyncrun_open = 6
let g:asynctasks_rtp_config = "tasks.ini"
" 全局的设置在 ~/.vim/tasks.ini

nnoremap <silent><F5> :AsyncTask file-run<CR>
inoremap <silent><F5> <C-o>:AsyncTask file-run<CR>
nnoremap <silent><F9> :AsyncTask file-build<CR>
inoremap <silent><F9> <C-o>:AsyncTask file-build<CR>

" <F9>编译，<F5>运行

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 13. BufOnly
" Delete all the buffers except the current/named buffer 
" See, https://github.com/vim-scripts/BufOnly.vim
" 主动工具
"----------------------------------------------------------
map <leader>bo :BufOnly<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use mouse in xterm
" Not use xterm any more
" now use alacritty
set ttymouse=sgr
set mouse=a
set nocompatible

" to solve a known issue of vim
" See, https://github.com/mg979/vim-visual-multi/issues/120
set term=xterm-256color

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
nmap <leader>w :w!<CR>
nnoremap <F2> :w!<CR>
" Fast saving in insert mode
inoremap <F2> <C-o>:w<CR>

" :W sudo saves the file 
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
" syntax enable
" This line must be before the highlight User0..9 group,
"   otherwise it would clear all custom highlights.
" Actually, it is OK to comment this line out, because vim-plug
"   helped us write it. See,
"   https://github.com/junegunn/vim-plug/issues/379

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

" set to let diff mode more clearly to compare
" See, https://vi.stackexchange.com/a/5689
" Edit by Zero.
" hi DiffText   cterm=none ctermfg=Black ctermbg=Red gui=none guifg=Black guibg=Red
" hi DiffChange cterm=none ctermfg=Black ctermbg=LightMagenta gui=none guifg=Black guibg=LightMagenta
" Well, actually vimdiff works fine without this setting,
"   not necessary to use anymore. The problem was recalled by myself suddenly
"   so I checked for solutions immediatly without have tried first...

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and zh_CN as the standard language
" now en_US, 2021.05.19
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,gbk2312,gbk,gb18030,ucs-bom,chinese,cp936
set encoding=utf-8
set langmenu=en_US
let $LANG = 'en_US.UTF-8'
language messages en_US.utf-8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
" set lbr
" set tw=500
" 不要断行

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" 自动把 json 文件格式化
nnoremap <F4> :execute '%!python -m json.tool' <bar> w<CR>
" 参考：https://vi.stackexchange.com/a/16908

" 把 Unicode 码替换为正常字符串
nnoremap <F12> :%s/\\u\(\x\{4\}\)/\=nr2char('0x'.submatch(1),1)/g<CR>
" 参考：https://vi.stackexchange.com/a/2303


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map <Space> to / (search) and Shift-<Space> to ? (backwards search)
map <space> /
map <S-Space> ?

" Disable highlight when <leader><CR> is pressed
map <silent> <leader><CR> :noh<CR>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
" 还需要好好学习一下 buffer
map <leader>bd :Bclose<CR>:tabclose<CR>gT
map <leader>x :bd<CR>

" Close all the buffers
" 还需要好好学习一下 buffer
map <leader>ba :bufdo bd<CR>

map <leader>l :bnext<CR>
nnoremap <F3> :bnext<CR>
inoremap <F3> <C-o>:bnext<CR>

map <leader>h :bprevious<CR>
nnoremap <F1> :bprevious<CR>
inoremap <F1> <C-o>:bprevious<CR>

" Useful mappings for managing tabs
" 还需要好好学习一下 tab
map <leader>tn :tabnew<CR>
map <leader>to :tabonly<CR>
map <leader>tc :tabclose<CR>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext 

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<CR>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<CR>:pwd<CR>

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use lightline plugin instead, 
"   see the Plugin section at the begining of this file.

" Always show the status line
" set laststatus=2

" Format the status line
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
execute "set <M-j>=\ej"
execute "set <M-k>=\ek"
" See, https://vi.stackexchange.com/a/2363

nmap <M-j> mz:m+<CR>`z
nmap <M-k> mz:m-2<CR>`z
vmap <M-j> :m'>+<CR>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<CR>`>my`<mzgv`yo`z

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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<CR>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><CR>//ge<CR>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<CR>

" Quickly open a markdown buffer for scribble
" map <leader>x :e ~/buffer.md<CR>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

