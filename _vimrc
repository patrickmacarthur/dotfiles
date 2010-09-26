" Begin .vimrc
"
" by Patrick MacArthur <generalpenguin89@gmail.com>

let loaded_matchparen = 1

if has("syntax")
  syntax on
  set background=dark
endif

" These are my settings; in (mostly) alphabetical order.  If you don't know what
" one of them does, run :help <name> from within vim.
set autoindent
set noesckeys
set expandtab
set guifont=Monospace\ 8
set guifontwide=Monospace\ 8
set nohlsearch
set number
set matchtime=2
set modeline
set incsearch
set printoptions=paper:letter,duplex:off
set pastetoggle=<f11>
set ruler
set shiftwidth=4
set showcmd
set showmatch
set smartindent
set smarttab
set tabstop=4
set textwidth=80
set wildmenu
set wrapmargin=8

set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
set formatoptions+=croql

set viminfo='200,<300,s150,%,h,!

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

if !exists("*CModeline")
  function CModeline( )
    append
/* vim: set et sw=4 tw=78: */
.
  endfunction
endif

if !exists("*GPLHeader")
  function GPLHeader( )
    -1 read !echo "/*  %"
    append

    Copyright (c) 2010 Patrick MacArthur
    
    This file is part of AwesomeProgram

    AwesomeProgram is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    AwesomeProgram is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with AwesomeProgram.  If not, see <http://www.gnu.org/licenses/>.
 */

.
    call CModeline()
    -1
  endfunction
endif

if !exists("*HSHeader")
  function HSHeader( )
    -1 read !echo "-- File: %"
    :2
  endfunction
endif

if has("autocmd")
  filetype plugin indent on

  augroup c
    autocmd!
    if !exists("*s:IncludeGuard")
      function s:IncludeGuard()
        0    !echo -n "\#ifndef " ; echo % | tr '[:lower:].' '[:upper:]_'
        read !echo -n "\#define " ; echo % | tr '[:lower:].' '[:upper:]_'
        read !echo
        read !echo
        read !echo "\#endif"
        :-1
      endfunction
      autocmd BufNewFile *.h,*.hh,*.hpp call <SID>IncludeGuard()
    endif
  augroup END

  augroup hs
    autocmd BufNewFile *.hs call HSHeader()
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

" End .vimrc
"
" vim: set et sw=2 ts=2 wm=2:
