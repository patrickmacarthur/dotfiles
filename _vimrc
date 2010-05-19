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

" Highlight whitespace at end of line.
" Original version: Credit goes to eaburns
"highlight WhitespaceEOL ctermbg=Red guibg=Red
"match WhitespaceEOL /\s\+$/
" New version: on only for C/C++ files, but also handles spaces before
" tabs and stuff like that
let c_space_errors = 1

if !exists("*s:IncludeGuard")
    function s:IncludeGuard()
        0    !echo -n "\#ifndef " ; echo % | tr '[:lower:].' '[:upper:]_'
        read !echo -n "\#define " ; echo % | tr '[:lower:].' '[:upper:]_'
        read !echo
        read !echo
        read !echo "\#endif"
        :-1
    endfunction
endif

if !exists("*CPPInputOperator")
    function CPPInputOperator()
        read !echo "istream & operator >> ( istream & s, `basename % .C` & v )"
        read !echo "{"
        read !echo "    v.input( s );"
        read !echo "    return s;"
        read !echo "}"
        read !echo
    endfunction
endif

if !exists("*CPPOutputOperator")
    function CPPOutputOperator()
        read !echo "ostream & operator << ( ostream & s, const `basename % .C` & v )"
        read !echo "{"
        read !echo "    v.output( s );"
        read !echo "    return s;"
        read !echo "}"
        read !echo
    endfunction
endif

augroup c
    autocmd!
    autocmd BufNewFile *.h call <SID>IncludeGuard()
    autocmd BufNewFile *.hpp call <SID>IncludeGuard()

    " Highlight lines that are over 80 characters in length.  Credit:
    " http://stackoverflow.com/questions/235439/vim-80-column-layout-concerns
    au BufWinEnter * if &textwidth > 8
    \ | let w:m2=matchadd('ErrorMsg', printf('\%%>%dv.\+', &textwidth), -1)
    \ | endif
augroup END

" Source local vimrc to grab local-only modifications to this file
source ~/.vimrc.local

" End .vimrc

