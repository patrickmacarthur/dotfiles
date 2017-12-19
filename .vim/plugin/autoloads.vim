" Plugin to set some functions to execute when files are loaded
" Maintainer:	Patrick MacArthur <patrick@patrickmacarthur.net>

" These cannot be put directly in vimrc or Red Hat's vim-minimal package
" will execute the contents of the functions instead of loading them as
" functions.

" Insert a simple Haskell header comment
function! s:HSHeader()
  -1 read !echo "-- File: %"
  :2
endfunction

" Creates the header for a header file, assuming current file is .h and empty
function! s:PosixHHeader()
  -1   !echo "/* %"
  read !echo " * Patrick MacArthur <contact@patrickmacarthur.net>"
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
    read !echo " * Patrick MacArthur <contact@patrickmacarthur.net>"
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
    read !echo " * Patrick MacArthur <contact@patrickmacarthur.net>"
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

" Creates the header for a .java file, assuming current file is empty
function! s:JavaHeader()
    let l:pkginfo = fnamemodify(expand("%"), ':h') . '/package-info.java'
    -1   !echo "/* % */"
    read !echo
    if filereadable(l:pkginfo)
        let l:cmd = "read !grep '^package' " . l:pkginfo . " 2>/dev/null"
        exec l:cmd
    endif
    read !echo
    read !echo "/** Documentation comment. */"
    read !echo "public class" $(basename % .java) "{"
    read !echo "}"
endfunction

if has("autocmd")
  augroup vimrc_autocmds
    " Clear existing autocmds
    au!

    " C/C++
    autocmd BufNewFile *.h call <SID>PosixHHeader()
    autocmd BufNewFile *.c call <SID>PosixCHeader()
    autocmd BufNewFile *.cxx,*.cpp,*.cc call <SID>CXXHeader()
    autocmd BufNewFile *.java call <SID>JavaHeader()

    " Haskell
    autocmd BufNewFile *.hs call <SID>HSHeader()
  augroup END
endif
