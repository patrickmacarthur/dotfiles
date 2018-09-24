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
  read !echo " * Patrick MacArthur <patrick@patrickmacarthur.net>"
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
    read !echo " * Patrick MacArthur <patrick@patrickmacarthur.net>"
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
    read !echo " * Patrick MacArthur <patrick@patrickmacarthur.net>"
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

augroup encrypted
  au!
  " Disable swap files, and set binary file format before reading the file
  autocmd BufReadPre,FileReadPre *.gpg
    \ setlocal noswapfile bin
  autocmd BufReadPre,FileReadPre *.asc
    \ setlocal noswapfile bin
  " Decrypt the contents after reading the file, reset binary file format
  " and run any BufReadPost autocmds matching the file name without the .gpg
  " extension
  autocmd BufReadPost,FileReadPost *.gpg
    \ execute "'[,']!gpg --quiet --decrypt --default-recipient-self" |
    \ setlocal nobin |
    \ execute "doautocmd BufReadPost " . expand("%:r")
  autocmd BufReadPost,FileReadPost *.asc
    \ execute "'[,']!gpg --quiet --decrypt --default-recipient-self" |
    \ setlocal nobin |
    \ execute "doautocmd BufReadPost " . expand("%:r")
  " Set binary file format and encrypt the contents before writing the file
  autocmd BufWritePre,FileWritePre *.gpg
    \ setlocal bin |
    \ '[,']!gpg --encrypt --default-recipient-self
  autocmd BufWritePre,FileWritePre *.asc
    \ setlocal bin |
    \ '[,']!gpg --armor --encrypt --default-recipient-self
  " After writing the file, do an :undo to revert the encryption in the
  " buffer, and reset binary file format
  autocmd BufWritePost,FileWritePost *.gpg
    \ silent u |
    \ setlocal nobin
  autocmd BufWritePost,FileWritePost *.asc
    \ silent u |
    \ setlocal nobin
augroup END
