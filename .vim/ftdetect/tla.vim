" Plugin to recognize TLA+ modules and TLC configuration files
" Last Change:	2013 Oct 02
" Maintainer:	Patrick MacArthur <patrick@patrickmacarthur.net>
" License:	BSD

autocmd BufNewFile,BufRead *.tla set filetype=tla

function! s:CheckTLAConfig()
  if filereadable(expand('%:h') . '/' . expand('%:t:r') . '.tla')
    set filetype=tlacfg
  endif
endfunction

autocmd BufNewFile,BufRead *.cfg call <SID>CheckTLAConfig()
