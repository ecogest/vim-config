if exists("current_compiler") | finish | endif
let current_compiler = "norminette"

CompilerSet makeprg=python3\ -m\ norminette

" CompilerSet errorformat =%PNorme:\ %f,
" CompilerSet errorformat+=%t%.%#\ (line\ %l\\,\ col\ %c):\ %m,
" CompilerSet errorformat+=%t%.%#\ (line\ %l):\ %m,
" CompilerSet errorformat+=%Q,
"
" CompilerSet errorformat =%P%f:\ KO!,
" CompilerSet errorformat+=%.%#(line:\ %l\\,\ col:\ %c):%m,
" CompilerSet errorformat+=%.%#(line:\ %l):%m,
" CompilerSet errorformat+=%Q,

CompilerSet errorformat =%P%f:\ Error!
CompilerSet errorformat+=Error:\ %s\ (line:%*[\ ]%l\\,\ col:%*[\ ]%c)%m
CompilerSet errorformat+=%-Q
