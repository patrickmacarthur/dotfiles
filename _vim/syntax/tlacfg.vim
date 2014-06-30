" Vim syntax file for TLC configuration files
" Language: TLC configuration language
" Maintainer: Patrick MacArthur <pmacarth@iol.unh.edu>
" Last Change: Wed Oct  2 14:25:28 EDT 2013

" Based on tla.vim by Diego Ongaro

if exists("b:current_syntax")
  finish
endif

" Keep these in alphabetical order.
syn keyword tlcKeyword       CONSTRAINT
syn keyword tlcKeyword       CONSTRAINTS
syn keyword tlcKeyword       CONSTANT
syn keyword tlcKeyword       CONSTANTS
syn keyword tlcKeyword       SPECIFICATION
syn keyword tlcKeyword       INVARIANT
syn keyword tlcKeyword       INVARIANTS
syn keyword tlcKeyword       PROPERTY
syn keyword tlcKeyword       PROPERTIES

syntax case ignore
syn keyword tlaTodo contained todo xxx fixme
syntax case match

syn keyword tlaBoolean FALSE
syn keyword tlaBoolean TRUE
syn match tlaNumber "\<\d\+\>"
syn region tlaString start=+"+ skip=+\\"+ end=+"+

syn match tlaOperator "[!,:<>=~\-|^+*&\$#%\./\\]"
syn match tlaOperator "\[\]"
syn match tlaOperator "!!"
syn match tlaOperator "??"
syn match tlaOperator "@@"
syn match tlaOperator "\\A"
syn match tlaOperator "\\E"

syn match tlaSpecial "[{}'\[]]"

syn match tlaDelimiter "-\{4,\}"

" Comments. This is defined so late so that it overrides previous matches.
syn region tlaComment start="\\\*" end="$" contains=tlaTodo
syn region tlaComment start="(\*" end="\*)" contains=tlaTodo,tlaComment

" Link the rules to some groups.
highlight link tlaBoolean        Boolean
highlight link tlaComment        Comment
highlight link tlaDelimiter      Delimiter
highlight link tlcKeyword        Keyword
highlight link tlaNumber         Number
highlight link tlaOperator       Operator
highlight link tlaSpecial        Special
highlight link tlaString         String
highlight link tlaTodo           Todo

let b:current_syntax = "tlacfg"
