" autoload/cpp.vim - Functions for autogenerating C++ code
" Maintainer:	Patrick MacArthur <patrick@patrickmacarthur.net>

if exists("g:loaded_cpp")
	finish
endif
let g:loaded_cpp = 1

" Insert automatically generated C++ input operator>> for current class
function! cpp#inputoperator()
  read !echo "istream & operator >> ( istream & s, `basename % .C` & v )"
  read !echo "{"
  read !echo "    v.input( s );"
  read !echo "    return s;"
  read !echo "}"
  read !echo
endfunction

" Insert automatically generated C++ output operator<< for current class
function! cpp#outputoperator()
  read !echo "ostream & operator << ( ostream & s, const `basename % .C` & v )"
  read !echo "{"
  read !echo "    v.output( s );"
  read !echo "    return s;"
  read !echo "}"
  read !echo
endfunction
