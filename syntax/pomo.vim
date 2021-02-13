" Vim syntax file
" Language:     pomo
" Maintainer:	Me
" Last Change:	2021

" If b:current_syntax is defined,
" some other syntax file, earlier in 'runtimepath' was already loaded
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Syntax {{{
"
" Guidelines:
" - avoid \zs (the first part can still obliterate other matches), use a
"   prefix group instead (with nextgroup)
"
" Titles:
syn match pomoDailyTodo '^\S Todo$'
syn match pomoPomo '^\S Pomo \d\+$'
syn match pomoTodo '^ \S Todo$'
syn match pomoBrief '^ \S Brief$' contained containedin=pomoBriefArea

" Areas:
syn match pomoStart '\%^' nextgroup=pomoFirstArea,pomoDailyTodoArea,pomoDailyTodo,pomoPomo
syn region pomoDailyTodoArea start='^\S Todo$' end='^\ze\S Pomo \d\+$' transparent nextgroup=pomoFirstArea
syn region pomoFirstArea start='^\S Pomo \d\+$' end='^\ze\S Pomo \d\+$' transparent contained nextgroup=pomoDoneArea
syn region pomoDoneArea start='^\S Pomo \d\+$' end='^\ze\S Pomo \d\+$' transparent contained nextgroup=pomoDoneArea
syn region pomoBriefArea start='^ \S Brief$' end='^\ze\S Pomo'

" Items:
syn cluster pomoItems contains=pomoItem,pomoCompleteItem,pomoIncompleteItem
syn match pomoItemStart '^\s*- ' nextgroup=@pomoItems
syn match pomoItem '^\s*- \[.*\] \v(\S.*)=$' contained containedin=pomoDailyTodoArea,pomoFirstArea
syn match pomoCompleteItem '^\s*- \v(\[\S+\]).*$' contained containedin=ALL
" Idem but after symbol substitution
exe 'syn match pomoCompleteItem #^\s*- '.g:pomo_done_symbol.'.*$#'
syn match pomoIncompleteItem '\[ ].*$' contained containedin=pomoDoneArea
exe 'syn match pomoIncompleteItem /'.g:pomo_empty_symbol.'.*$/ contained containedin=pomoDoneArea'

" Conceals:
syn match pomoListChar '-' contained containedin=pomoItemStart,@pomoItems conceal cchar=•

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

let b:current_syntax='pomo'

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: ts=8 sw=2
