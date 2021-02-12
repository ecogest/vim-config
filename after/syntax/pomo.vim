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
syn region pomoDailyTodoArea start='^\S Todo$' end='^\ze\S Pomo \d\+$' transparent nextgroup=pomoFirstArea
syn region pomoFirstArea start='^\S Pomo \d\+$' end='^\ze\S Pomo \d\+$' transparent contained
syn region pomoArea start='^\S Pomo \d\+$' end='^\ze\S Pomo \d\+$' transparent
syn region pomoBriefArea start='^ \S Brief$' end='^\ze\S Pomo' keepend

" Items:
syn match pomoItem '^\s*- \[.*\] \v(\S.*)=$'
syn match pomoCompleteItem '^\s*- \v(\[\S+\]).*$' contained containedin=pomoItem
" Idem but after symbol substitution
exe 'syn match pomoCompleteItem #^\s*- '.g:pomo_done_symbol.'.*$# containedin=pomoItem'
syn match pomoIncompleteItem '^\s*- \[ ].*$' contained containedin=pomoArea

" Conceals:
syn match pomoListChar '^ \zs-\ze \[.*\]' containedin=pomoItem,pomoCompleteItem conceal cchar=•
exe 'syn match pomoListChar #^ \zs-\ze '.g:pomo_done_symbol.'# containedin=pomoItem,pomoCompleteItem conceal cchar=•'

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
