if exists('b:my_c_config')
	finish
endif
let b:my_c_config = 1

" Options {{{
"
setl tabstop=4
setl shiftwidth=4
setl noexpandtab

" }}}
" Folding {{{
"
" Fold test_ functions:
" see :h fold-expr | :h expr-=~
" I would have tried to fold with syntax but every other function if folding
"
setl fdm=expr
setl foldexpr=c_fold#c_fold(v:lnum)
setl concealcursor=n

"}}}
" Comments {{{
"
" Comment style:
" (see options commentsting and comments)
setl comments=sr:/*,mb:**,ex:*/,://
" original one
" setl comments=sO:*\ -,mO:**\ \ ,exO:*/,s1:/*,mb:**,ex:*/,://

" tComment style:
let b:tcomment_block_fmt_c = {
			\ 'mode': 'B',
			\ 'rxbeg': '\s*\*\+', 'rxmid': '\s*\*\*', 'rxend': '\s*\*/',
			\ 'begin': '/*', 'middle': '** ', 'end': '*/',
			\ 'commentstring': '/* %s */',
			\ 'replacements': {
				\ '*/': {
					\ 'subst': '|)}>#',
					\ 'guard_rx': '^\s*/\?\*'
					\ },
				\ '/*': {
					\ 'subst': '#<{(|',
					\ 'guard_rx': '^\s*/\?\*'
				\ }
			\ }
\ } " replacements subst is used to deal with nested comments
" to systematically call block_fmt
" call tcomment#type#Define('c', b:tcomment_block_fmt_c )
"}}}
" Header Switch{{{
"
let g:root_directories = [ ':git:' , '/' ]
let g:header_directories = [ 'includes', 'include' ]
let g:test_directories = [ 'tests', 'test' ]

" GoTo commands
command! CSwitchGoToTest call c_switch#go_to_test_file()
command! CSwitchGoToHeader call c_switch#go_to_header()
command! CSwitchGoToCmake call c_switch#go_to_cmake_file()
nnoremap <buffer> <leader>ct :CSwitchGoToTest<CR>
nnoremap <buffer> <leader>ch :CSwitchGoToHeader<CR>
nnoremap <buffer> <leader>cm :CSwitchGoToCmake<CR>
nnoremap <buffer> <leader>cvt <C-W>v:CSwitchGoToTest<CR>
nnoremap <buffer> <leader>cvh <C-W>v:CSwitchGoToHeader<CR>
nnoremap <buffer> <leader>cvm <C-W>v:CSwitchGoToCmake<CR>
nnoremap <buffer> <leader>cst <C-W>s:CSwitchGoToTest<CR>
nnoremap <buffer> <leader>csh <C-W>s:CSwitchGoToHeader<CR>
nnoremap <buffer> <leader>csm <C-W>s:CSwitchGoToCmake<CR>
" Add source to CmakeLists.txt
command! CSwitchAddSourceToCmakeLists call c_switch#add_current_file_to_cmakelists()
nnoremap <leader>ca :CSwitchAddSourceToCmakeLists<CR>
"}}}
" Prototype To def{{{
command! -nargs=1 ProtoToDefPaste call proto_to_def#proto_to_def_paste(<f-args>)
command! -nargs=1 DefToProtoPaste call proto_to_def#def_to_proto_paste(<f-args>)
command! -nargs=1 ProtoDefAlternatePaste call proto_to_def#alternate_paste(<f-args>)

noremap <buffer> <leader>ap :ProtoDefAlternatePaste "<CR>
noremap <buffer> <leader>aP :ProtoDefAlternatePaste +<CR>

"}}}
