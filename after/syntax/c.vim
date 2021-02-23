" Various global syntax options:
" syn include <sfile>:p:h/global.vim
runtime! syntax/global.vim " does the same

" Hilight the typedefs by adding them to cType:
syn match cType '\<t_\w\+'

" Hilight comment titles:
syn keyword cCommentWarning OBSOLETE WARNING FIXIT PROTECT DEPRECATED contained
hi cCommentWarning guifg=orange

syn match cCommentHeader  '\v[[:upper:],\- ]+\ze(:|$)' contained contains=cCommentWarning,cTodo
hi cCommentHeader gui=bold guifg=grey

syn cluster cCommentGroup add=cCommentHeader,cCommentWarning

" Dim parent object like obj-> or obj.
syn match cParentStruct '\v(-\>|\.)=\w+\ze(-\>|\.)' containedin=@cRainbowOperators
hi def link cParentStruct asciidocListingBlock

" Hilight differently comment characters
syn match cCommentMiddle '^\s*\*\*' contained containedin=cComment nextgroup=cCommentHeader
syn match cCommentLStart '//' contained containedin=cCommentL nextgroup=cCommentHeader conceal cchar=
hi def link cCommentMiddle SpecialKey
hi! def link cCommentStart cCommentMiddle
hi! def link cCommentLStart cCommentMiddle

" Statement style (return, break)
hi! def link cStatement Statement
