" Begin .vimrc
"
" by Patrick MacArthur <generalpenguin89@gmail.com>

" Start out with vim (not vi) defaults
set nocompatible

filetype plugin indent on

if has("syntax")
  if has("gui_running")
    syntax enable
    set hlsearch
    let g:liquidcarbon_high_contrast=1
    colorscheme liquidcarbon
  elseif &t_Co >= 256
    syntax enable
    set hlsearch
    colorscheme ir_black
  elseif &t_Co > 2
    set background=dark
    syntax enable
    set hlsearch
  else
    syntax off
    set nohlsearch
  endif
endif

if has("gui_running")
  set cursorline
  set guifont=Monospace\ 10
  set guifontwide=Monospace\ 10
  set guioptions-=T

  runtime ftplugin/man.vim
  nmap K :Man <cword><CR>
endif

" These are my settings; in (mostly) alphabetical order.  If you don't know what
" one of them does, run :help <name> from within vim.
set autoindent
set nobackup
set noesckeys
set noexpandtab
set number
set matchtime=2
set incsearch
set printoptions=paper:letter,duplex:off
set pastetoggle=<f11>
set ruler
set shiftwidth=8
set showcmd
set showmode
set showmatch
set smartindent
set smarttab
set tabstop=8
set textwidth=80
set wildmenu
set wrapmargin=8

" set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
" set formatoptions+=croql

" Enable saving things into viminfo.  However, vim will complain if we try to
" use a newer feature in an older version, so test the version before enabling
" newer viminfo features.
if has("viminfo")
  if version >= 700
    set viminfo='200,<300,s150,%,h,!
  elseif version >= 600
    set viminfo='200,\"300,%,h,!
  endif
endif

" Assume /bin/sh is the POSIX shell, not the original Bourne shell
let g:is_posix = 1

" Highlight whitespace at end of line.
" New version: on only for C/C++ files, but also handles spaces before
" tabs and stuff like that
let c_space_errors = 1


" Insert automatically generated C++ input operator>> for current class
function! CPPInputOperator()
  read !echo "istream & operator >> ( istream & s, `basename % .C` & v )"
  read !echo "{"
  read !echo "    v.input( s );"
  read !echo "    return s;"
  read !echo "}"
  read !echo
endfunction

" Insert automatically generated C++ output operator<< for current class
function! CPPOutputOperator()
  read !echo "ostream & operator << ( ostream & s, const `basename % .C` & v )"
  read !echo "{"
  read !echo "    v.output( s );"
  read !echo "    return s;"
  read !echo "}"
  read !echo
endfunction

" Insert a simple Haskell header comment
function! s:HSHeader()
  -1 read !echo "-- File: %"
  :2
endfunction

" Creates the header for a header file, assuming current file is .h and empty
function! s:PosixHHeader()
  -1   !echo "/* %"
  read !echo " *"
  read !echo " * Description of this file goes here (TODO)"
  read !echo " *"
  read !echo " * Patrick MacArthur <pio3@wildcats.unh.edu>"
  read !echo " */"
  read !echo
  read !echo -n "\#ifndef " ; echo % | tr '[:lower:].' '[:upper:]_'
  read !echo -n "\#define " ; echo % | tr '[:lower:].' '[:upper:]_'
  read !echo
  read !echo
  read !echo "\#endif"
  read !echo "/* vim: set shiftwidth=8 tabstop=8 noexpandtab : */"
  :-3
endfunction

" Creates the header for a .c file, assuming current file is empty
function! s:PosixCHeader()
    -1   !echo "/* %"
    read !echo " *"
    read !echo " * Description of this file goes here (TODO)"
    read !echo " *"
    read !echo " * Patrick MacArthur <pio3@wildcats.unh.edu>"
    read !echo " */"
    read !echo
    read !echo -n "\#include _POSIX_C_SOURCE 200112L"
    read !echo -n "\#include _ISOC99_SOURCE"
    read !echo -n "\#include __EXTENSIONS__"
    read !echo -n "\#include _XOPEN_SOURCE 600"
    read !echo
    read !echo
    read !echo "/* vim: set shiftwidth=8 tabstop=8 noexpandtab : */"
    :-2
endfunction

" C folding
" - reserve 1 column on the left for folding tree, assuming > 80 columns
" - fold by syntax, use {}'s
" - only fold outermost entities
function! s:EnableCFolding()
  setlocal foldmethod=marker
  setlocal foldnestmax=2
  if winwidth(0) > 90
    setlocal foldcolumn=4
  endif
endfunction

function! s:SetSMLIndent()
  set shiftwidth=4
  set tabstop=4
  set wrapmargin=0
endfunction

if has("autocmd")
  augroup vimrc_autocmds
    " Clear existing autocmds
    au!

    " C/C++
    autocmd BufNewFile *.h call <SID>PosixHHeader()
    autocmd BufNewFile *.c call <SID>PosixCHeader()
    autocmd BufReadPost,BufNewFile *.h,*.hh,*.hpp call <SID>EnableCFolding()
    autocmd BufReadPost,BufNewFile *.c,*.cc,*.cpp,*.C call <SID>EnableCFolding()

    " SML
    autocmd BufReadPost,BufNewFile *.sml call <SID>SetSMLIndent()

    " Haskell
    autocmd BufNewFile *.hs call <SID>HSHeader()
  augroup END
endif

" For vim-latexsuite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_MultipleCompileFormats = "dvi pdf"

" Source local vimrc to grab local-only modifications to this file
if filereadable(expand("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif

nohlsearch

" End .vimrc
"
" vim: set et sw=2 ts=2 wm=2:
