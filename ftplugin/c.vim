if exists('g:my_c_config')
	finish
endif

" see :h fold-expr | :h expr-=~
" I would have tried folding with syntax if I could prenvent normal function
" from folding

set fdm=expr
set foldexpr=c_fold_test#fold_test_functions(v:lnum)
