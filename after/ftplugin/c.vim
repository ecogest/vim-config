" if exists('b:my_c_config')
" 	finish
" endif
" let b:my_c_config = 1

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
let g:header_location = [ ':git:/includes', '.' ]
let g:test_location = [ ':git:/tests', '.' ]

command! CSwitchGoToTest call c_switch#go_to_test_file()
command! CSwitchGoToHeader call c_switch#go_to_header()
command! CSwitchGoToCmake call c_switch#go_to_cmake_file()
nnoremap <leader>gt :CSwitchGoToTest<CR>
nnoremap <leader>gh :CSwitchGoToHeader<CR>
nnoremap <leader>gcm :CSwitchGoToCmake<CR>
"}}}
