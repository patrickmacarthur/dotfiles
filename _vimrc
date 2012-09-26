" Begin .vimrc
"
" by Patrick MacArthur <generalpenguin89@gmail.com>

" Start out with vim (not vi) defaults
set nocompatible

" Load all plugins that I've installed into .vim/bundle
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

if has("syntax")
  if has("gui_running")
    syntax enable
    set hlsearch
    colorscheme solarized
  elseif &t_Co > 2
    syntax enable
    set hlsearch
    colorschem solarized
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
set number
set matchtime=2
set incsearch
set printoptions=paper:letter,duplex:off
set pastetoggle=<f11>
set ruler
set showcmd
set showmode
set showmatch
set smarttab
set wildmenu
set wrapmargin=8

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
let c_space_errors = 1

" Insert a simple Haskell header comment
function! s:HSHeader()
  -1 read !echo "-- File: %"
  :2
endfunction

" Creates the header for a header file, assuming current file is .h and empty
function! s:PosixHHeader()
  -1   !echo "/* %"
  read !echo " * Patrick MacArthur <pio3@wildcats.unh.edu>"
  read !echo " * Description of this file goes here (TODO)"
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

" Creates the header for a C++ file, assuming current file is empty
function! s:CXXHeader()
    -1   !echo "/* %"
    read !echo " * Patrick MacArthur <pio3@wildcats.unh.edu>"
    read !echo " * Description of this file goes here (TODO)"
    read !echo " */"
    read !echo
    read !echo
    read !echo "/* vim: set shiftwidth=8 tabstop=8 noexpandtab : */"
    :-2
endfunction

" Creates the header for a .c file, assuming current file is empty
function! s:PosixCHeader()
    -1   !echo "/* %"
    read !echo " * Patrick MacArthur <pio3@wildcats.unh.edu>"
    read !echo " * Description of this file goes here (TODO)"
    read !echo " */"
    read !echo
    read !echo -n "\#define _POSIX_C_SOURCE 200112L"
    read !echo -n "\#define _XOPEN_SOURCE 600"
    read !echo
    read !echo
    read !echo "/* vim: set shiftwidth=8 tabstop=8 noexpandtab : */"
    :-2
endfunction

if has("autocmd")
  augroup vimrc_autocmds
    " Clear existing autocmds
    au!

    " C/C++
    autocmd BufNewFile *.h call <SID>PosixHHeader()
    autocmd BufNewFile *.c call <SID>PosixCHeader()
    autocmd BufNewFile *.cxx,*.cpp,*.cc call <SID>CXXHeader()

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

" Unhighlight any previous searches because I find it annoying
nohlsearch

" Automatically detect filetypes and use the appropriate plugins
filetype plugin indent on

" End .vimrc
"
" vim: set et sw=2 ts=2 wm=2:
