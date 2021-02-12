" Vim syntax file
" Language:	pomo
" Maintainer:	Me
" Last Change:	2021

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match pomoDailyTodo '^# Todo$'
syn match pomoPomo '^# Pomo \d\+$'
" syn match pomoTomato '^#\ze ' contained containedin=pomoPomo transparent conceal cchar=🍅 " cchar=

syn match pomoTodo '^## Todo$'

syn region pomoBriefArea start='^## Brief$' end='^\ze# Pomo' keepend
syn match pomoBrief '^## Brief$' contained containedin=pomoBriefArea

syn match pomoItem '^\s*- \[.*\] \v(\S.*)=$'
syn match pomoCompleteItem '^\s*- \[\S\+\].*$' contained containedin=pomoItem

hi! def link pomoDailyTodo Todo
hi! def link pomoPomo Keyword

hi! def link pomoTodo pomoDailyTodo

hi! def link pomoBriefArea Typedef
hi! def link pomoBrief Typedef

hi! def link pomoItem Function
hi! def link pomoCompleteItem Constant
