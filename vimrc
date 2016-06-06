"------------------------------------------------
"try to add some git change

"------------------------------------------------
"autocomplete bracket
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i

function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction

"------------------------------------------------
"key mapping
map <C-k>   <ESC>:NERDTreeToggle<CR>

"forward & backward
"map <C-->   <C-o>
"map <C-+>   <C-i>

"moving inside window
map <S-j>   <C-W>j
map <S-k>   <C-W>k
map <S-h>   <C-W>h
map <S-l>   <C-W>l

"a.vim
map <C-\>   <ESC>:A<CR>

"CtrlP.vim
map <C-p>   <ESC>:CtrlP<CR>
"show current buffer tags
map <C-r> <ESC>:CtrlPBufTag<CR>

"ack.vim
map <C-f> <ESC>:Ack <cword><CR>

"quickfix window
map <C-n> <ESC>:cn<CR>
map <C-m> <ESC>:cp<CR>

"tagbar
nnoremap <C-t> :TagbarToggle<CR>


"------------------------------------------------
"vim features

"switch buffer without saving
set hidden

"no swap file
set noswapfile

"no compatible mode
set nocp

"enable status bar ruler
set ru

"enable highlight search word
set hls

"enable incremental search
set is

"enable syntax highlight
syntax on

"enable backspace to erase indent, end of line, line start
set backspace=indent,eol,start

"encoding = utf8
set encoding=utf-8

"search ignore case
set ignorecase

"enable auto encoding recongnization
"set fileencodings=ucs-bom,utf-9,cp030,gb18030,big5,euc-jp,euc-kr,latin1

"avoid special character display issue
set ambiwidth=double

"auto indent on different file type
filetype plugin indent on

"------------------------------------------------
"editor feature

"auto indent space = 4
set sw=4

"tab size = 4
set ts=4

"space replace tab
set et

"auto delete tab space
set smarttab

"match brace
set sm

"auto indent
set ai

"no wrap line
set nowrap

"line number
set number numberwidth=4

"------------------------------------------------
"look and feel
:colo default 

"------------------------------------------------
"functions


