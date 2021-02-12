" Vim syntax file
" Language:	pomo
" Maintainer:	Me
" Last Change:	2021

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Syntax {{{
"
" Titles:
syn match pomoDailyTodo '^\S Todo$'
syn match pomoPomo '^\S Pomo \d\+$'
syn match pomoTodo '^ \S Todo$'
syn match pomoBrief '^ \S Brief$' contained containedin=pomoBriefArea

" Areas:
syn region pomoArea start='^\S Pomo \d\+$' end='^\ze\S Pomo \d\+$' transparent
" syn match pomoTomato '^#\ze ' contained containedin=pomoPomo transparent conceal cchar=🍅 " cchar=
syn region pomoBriefArea start='^ \S Brief$' end='^\ze\S Pomo' keepend

" Items:
syn match pomoItem '^\s*- \[.*\] \v(\S.*)=$'
syn match pomoCompleteItem '^\s*- \[\S\+\].*$' contained containedin=pomoItem
syn match pomoIncompleteItem '^\s*- \[ ].*$' contained containedin=pomoArea

" }}}
" Higlights {{{
"
" Titles:
hi! def link pomoDailyTodo Todo
hi! def link pomoPomo Keyword
hi! def link pomoTodo pomoDailyTodo
hi! def link pomoBrief Typedef

" Areas:
hi! def link pomoBriefArea Typedef

" Items:
hi! def link pomoItem Function
hi! def link pomoCompleteItem Constant
hi! def link pomoIncompleteItem DiffChange

" }}}
