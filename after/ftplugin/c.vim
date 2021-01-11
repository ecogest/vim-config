if exists('b:my_c_config')
	finish
endif
let b:my_c_config = 1

" see :h fold-expr | :h expr-=~
" I would have tried folding with syntax if I could prenvent normal function
" from folding

setl fdm=expr
setl foldexpr=c_fold_test#fold_test_functions(v:lnum)

" Comment style (see options commentsting and comments)
setl comments=sr:/*,mb:**,ex:*/,://
" original one
" set comments=sO:* -,mO:**\ \ ,exO:*/,s1:/*,mb:**,ex:*/,://"
