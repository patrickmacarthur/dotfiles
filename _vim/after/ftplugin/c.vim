" after/ftplugin/c.vim - My custom settings for C files
" Maintainer:	Patrick MacArthur <generalpenguin89@gmail.com>

setlocal autoindent
setlocal noexpandtab
setlocal shiftwidth=8
setlocal tabstop=8
setlocal textwidth=80

" C indentation
setlocal cindent
setlocal cinoptions=& cinoptions=:0

" C folding
" - reserve 1 column on the left for folding tree, assuming > 80 columns
" - fold by syntax, use {}'s
" - only fold outermost entities
setlocal foldmethod=marker
setlocal foldnestmax=2
if winwidth(0) > 90
	setlocal foldcolumn=4
endif
