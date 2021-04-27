" Options {{{
if !exists('g:pretty_header_placeholder')
	let g:pretty_header_placeholder = '='
endif
" }}}

" Private functions {{{

" Returns the main string (# ======= Text ======== #)
fu! s:commentstring_header_string(text, cms, placeholder)
	let cms = a:cms
	let total_width = &colorcolumn - 1
	" Check if the format if left only (#%s) or on both sides (/*%s*/)
	let comment_char_left_only = (match(a:cms, '%s$') != -1)
	if comment_char_left_only
		" we want the format to be symetrical : /* %s */ instead of /* %s
		let cms = cms . join(reverse(split(matchstr(cms, '.*\ze%s'), '.\zs')), '')
	endif
	" Everthing but %s in cms. Ex with '/*%s*/' it will be 4 (/**/).
	let boundary_width = strlen(cms) - 2
	" How many placeholder signs required
	let placeholder_width = total_width
				\ - strlen(a:text)
				\ - boundary_width
				\ - 4 " 2 spaces surrounding the text + 2 spaces between boundary and placeholders
	let left_placeholder_width = placeholder_width / 2
	let right_placeholder_width = placeholder_width - left_placeholder_width
	let final_text = ' ' . repeat(a:placeholder, left_placeholder_width)
				\ . ' ' . a:text
				\ . ' ' . repeat(a:placeholder, right_placeholder_width) . ' '
	return printf(cms, final_text)
endfu

fu! s:commentstring_header(text, cms, placeholder)
	let header_string = s:commentstring_header_string(a:text, a:cms, a:placeholder)
	call append(line('.') - 1, header_string)
endfu

fu! s:long_format_header(text, sr, mb, ex, placeholder)
	let cms = a:mb . '%s'
	let header_string = s:commentstring_header_string(a:text, cms, a:placeholder)
	call append(line('.') - 1, [a:sr, header_string, a:ex])
endfu
" }}}

" Public functions {{{
fu! pretty_header#pretty_header(text)
	" Simple format (ex '/*%s*/')
	let cms = &commentstring
	" Complex format (ex 'sr:/*,mb:**,ex:*/,://)
	let com = &comments
	let sr = matchstr(com, 'sr:\zs[^,]*')
	let mb = matchstr(com, 'mb:\zs[^,]*')
	let ex = matchstr(com, 'ex:\zs[^,]*')
	" Placeholder for the section (ex: = will give '/* ==== Header ==== */)
	let placeholder = g:pretty_header_placeholder
	if !empty(sr) && !empty(mb) && !empty(ex)
		call s:long_format_header(a:text, sr, mb, ex, placeholder)
	else
		call s:commentstring_header(a:text, cms, placeholder)
	endif
endfu
"}}}
