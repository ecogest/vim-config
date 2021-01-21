" Various global syntax options:
" syn include <sfile>:p:h/global.vim
runtime! syntax/global.vim " does the same

" Hilight the typedefs by adding them to cType:
syn match cType '\<t_\w\+'

" Hilight comment titles:
syn keyword cCommentWarning OBSOLETE WARNING FIXIT PROTECT DEPRECATED contained
hi cCommentWarning guifg=orange

syn match cCommentHeader  '\v^\A+\zs[[:upper:],\- ]+\ze(:|$)' contained contains=cCommentWarning,cTodo
hi cCommentHeader gui=bold guifg=grey

syn cluster cCommentGroup add=cCommentHeader,cCommentWarning
