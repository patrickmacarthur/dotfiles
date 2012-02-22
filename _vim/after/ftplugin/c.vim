" after/ftplugin/c.vim - My custom settings for C files
" Maintainer:	Patrick MacArthur <generalpenguin89@gmail.com>

setlocal autoindent
setlocal noexpandtab
setlocal shiftwidth=8
setlocal tabstop=8
setlocal textwidth=80

" C/C++ indentation
setlocal cindent
setlocal cinoptions=& cinoptions=:0,g0,N-s

" C folding
" - Fold using markers, since I hate the way that vim folds C-style comments.
"   I want markers in the rare case I'm dealing with a gigantic C source file.
" - Reserve 4 column on the left for folding tree, but only if we have room
"   for them.
setlocal foldmethod=marker
setlocal foldnestmax=2
if winwidth(0) > 90
	setlocal foldcolumn=4
endif
