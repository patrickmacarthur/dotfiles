" Begin .vimrc
"
" by Patrick MacArthur <generalpenguin89@gmail.com>

" Start out with vim (not vi) defaults
set nocompatible

if has("syntax")
  if has("gui_running") || &t_Co >= 256
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

filetype plugin indent on

" These are my settings; in (mostly) alphabetical order.  If you don't know what
" one of them does, run :help <name> from within vim.
set autoindent
set nobackup
set noesckeys
set expandtab
set guifont=Monospace\ 8
set guifontwide=Monospace\ 8
set number
set matchtime=2
set incsearch
set printoptions=paper:letter,duplex:off
set pastetoggle=<f11>
set ruler
set shiftwidth=2
set showcmd
set showmode
set showmatch
set smartindent
set smarttab
set tabstop=2
set textwidth=80
set wildmenu
set wrapmargin=8

" set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
" set formatoptions+=croql

set viminfo='200,<300,s150,%,h,!

" Assume /bin/sh is the POSIX shell, not the original Bourne shell
let g:is_posix = 1

" Highlight whitespace at end of line.
" New version: on only for C/C++ files, but also handles spaces before
" tabs and stuff like that
let c_space_errors = 1


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

if !exists("*HSHeader")
  function HSHeader( )
    -1 read !echo "-- File: %"
    :2
  endfunction
endif

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

" C folding
" - reserve 1 column on the left for folding tree, assuming > 80 columns
" - fold by syntax, use {}'s
" - only fold outermost entities
if !exists("*EnableCFolding")
  function EnableCFolding()
    setlocal foldmethod=syntax
    setlocal foldnestmax=1
    if winwidth(0) > 80
      setlocal foldcolumn=1
    endif
  endfunction
endif

if !exists("*SetSMLIndent")
  function SetSMLIndent()
    set shiftwidth=4
    set tabstop=4
    set wrapmargin=0
  endfunction
endif

if has("autocmd")

  " C/C++
  autocmd BufNewFile *.h,*.hh,*.hpp call <SID>IncludeGuard()
  autocmd BufReadPost,BufNewFile *.h,*.hh,*.hpp call EnableCFolding()
  autocmd BufReadPost,BufNewFile *.c,*.cc,*.cpp,*.C call EnableCFolding()

  " SML
  autocmd BufReadPost,BufNewFile *.sml call SetSMLIndent()

  " Haskell
  autocmd BufNewFile *.hs call HSHeader()
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
