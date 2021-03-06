" if exists("b:my_plugin")
"   finish
" endif

" Import c parameters:
runtime! ftplugin/c.vim

" Options:
setl matchpairs+=<:>
" Compose filetype for test files (setl ft=gtest.cpp). Good idea but does not
" work well with coc syntax
" if expand("%") =~# '.*_test\.cc'
" 	setl ft=gtest.cpp
" endif

" Protect my headers:

command! Hprotect call header42#protect_new_header()
command! Hupdate call header42#update_header_protection()
augroup Hupdate
	au!
	au BufWritePre *.h,*.hpp Hupdate
augroup END
" in vimrc you should put: au BufNewFile *.h Hprotect

" Hpp template:
command! HppTemplate call hpp_template#insert_hpp_template('.', expand('%:t:r'))
