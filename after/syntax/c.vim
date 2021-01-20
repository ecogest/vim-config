" hilight the typedefs by adding them to cType
syn match cType '\<t_\w\+'

" Hilight comment titles
syn keyword cCommentWarning OBSOLETE WARNING FIXIT contained
hi cCommentWarning guifg=orange
syn match cCommentHeader  '[[:upper:]]\+\ze\(:\|$\)' contained
hi cCommentHeader gui=bold guifg=grey
syn cluster cCommentGroup add=cCommentHeader,cCommentWarning
