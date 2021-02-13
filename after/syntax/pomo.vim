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
syn match pomoItem '^\s*- \[.*\] \v(\S.*)=$'
syn match pomoCompleteItem '^\s*- \v(\[\S+\]).*$' contained containedin=pomoItem
" Idem but after symbol substitution
exe 'syn match pomoCompleteItem #^\s*- '.g:pomo_done_symbol.'.*$#'
syn match pomoIncompleteItem '^\s*- \[ ].*$' contained containedin=pomoDoneArea

" Conceals:
syn match pomoListChar '^\s*\zs-\ze \[.*\]' containedin=pomoItem,pomoCompleteItem conceal cchar=•
exe 'syn match pomoListChar #^\s*\zs-\ze '.g:pomo_done_symbol.'# containedin=pomoItem,pomoCompleteItem conceal cchar=•'

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
