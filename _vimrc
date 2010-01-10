" Begin .vimrc
"
" by Patrick MacArthur <generalpenguin89@gmail.com>

let loaded_matchparen = 1

syntax on

set wrapmargin=8
set ruler
set number
set tabstop=4
set shiftwidth=4
set expandtab
set nohlsearch
set autoindent

set guifont=Monospace\ 8
set guifontwide=Monospace\ 8

set textwidth=72

set background=dark

set showmatch
set matchtime=2
set incsearch
set showcmd
set smartindent
set smarttab

set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
set formatoptions+=croql

set viminfo='200,<300,s150,%,h,!

let g:is_posix = 1

" Enable support for modelines embedded within files
set modeline

" Source local vimrc to grab local-only modifications to this file
source! .vimrc.local

" End .vimrc

