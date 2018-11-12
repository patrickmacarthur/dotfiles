" Begin .vimrc
"
" by Patrick MacArthur <patrick@patrickmacarthur.net>

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
  set guifont=Ubuntu\ Mono\ 12
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
set list
set listchars=tab:»\ ,extends:>,precedes:<,nbsp:+,trail:·
set printoptions=paper:letter,duplex:off
set pastetoggle=<f11>
set ruler
set showcmd
set showmode
set showmatch
set smarttab
set wildignore+=*.o,*.trs,configure,Makefile.in,tags
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

" For vim-latexsuite
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_MultipleCompileFormats = "dvi pdf"

let g:tex_indent_brace = 0
let g:tex_indent_items = 0
let g:tex_indent_and = 0
let g:tex_noindent_env = 'document\|verbatim\|lstlisting\|proof'

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

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
