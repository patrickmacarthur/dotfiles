" Plugin to set reasonable settings for TLA+ modules
" Last Change:	2013 Oct 02
" Maintainer:	Patrick MacArthur <pmacarth@iol.unh.edu>
" License:	BSD

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

if exists("g:loaded_tla_ftplugin")
  finish
endif
let g:loaded_tla_ftplugin = 1

setlocal textwidth=0
setlocal expandtab
setlocal shiftwidth=1
setlocal softtabstop=2
setlocal makeprg=sany\ %
