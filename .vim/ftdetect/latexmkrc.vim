" Plugin to recognize latexmkrc files as Perl source code
" Maintainer: Patrick MacArthur <patrick@patrickmacarthur.net>
" License:    BSD

autocmd BufNewFile,BufRead latexmkrc set filetype=perl makeprg=latexmk
autocmd BufNewFile,BufRead .latexmkrc set filetype=perl makeprg=latexmk
