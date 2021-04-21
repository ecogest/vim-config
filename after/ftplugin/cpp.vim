" if exists("b:my_plugin")
"   finish
" endif

" Import c parameters:
runtime! ftplugin/c.vim

" Protect my headers:

command! Hprotect call header42#protect_new_header()
command! Hupdate call header42#update_header_protection()
au BufWritePre *.h,*.hpp Hupdate
" in vimrc you should put: au BufNewFile *.h Hprotect

" Hpp template:
command! HppTemplate call hpp_template#insert_hpp_template('.', expand('%:t:r'))
