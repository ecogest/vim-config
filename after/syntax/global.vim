" Fold titles in bold:
syn match customCommentFoldTitle '\w.*\ze.*{{\(\){$' contained containedin=.*Comment.*
hi! link customCommentFoldTitle Title

" Classic comment titles:
syn match customCommentTitle '\w.*:$' contained containedin=.*Comment.*
hi! link customCommentTitle vimCommentTitle

" Conceal markers:
" setl conceallevel=2
syn match customConcealedMarkerStart '{{\(\){$' contained containedin=.*Comment.* conceal cchar=⟪
hi! link customConcealedMarkerStart Comment
syn match customConcealedMarkerStart '}}\(\)}$' contained containedin=.*Comment.* conceal cchar=⟫
hi! link customConcealedMarkerEnd Comment
