" Private Funcitons{{{
"
fu! s:is_prototype(string)
	return a:string =~ ';\n\=$'
endfu

fu! s:is_def(string)
	return !s:is_prototype(a:string)
endfu

"}}}

" Public Functions{{{
"
fu! proto_to_def#proto_to_def_paste(register)
	let prototype = getreg(a:register)
	if !s:is_prototype(prototype)
		echo 'The text in register `' . a:register . "' is not a protoype."
		return
	endif
	let definition = [ matchstr(prototype, '\s*\zs.*\ze;\n\=$'), '{', '}', '' ]
	call append('.', definition)
	normal! j=2jj
endfu

fu! proto_to_def#def_to_proto_paste(register)
	let definition = getreg(a:register)
	if !s:is_def(definition)
		echo 'The text in register `' . a:register . "' is not a definition."
		return
	endif
	let prototype = matchstr(definition, '^\s*\zs[^{\n]*')
	" Remove trailing spaces if required and append ';'
	let prototype = prototype[:match(prototype, '\s*$') - 1] . ';'
	call append('.', prototype)
	normal! j==
endfu

" If prototype found in register, paste empty definition, paste prototype
" otherwise
fu! proto_to_def#alternate_paste(register)
	if s:is_prototype(getreg(a:register))
		call proto_to_def#proto_to_def_paste(a:register)
	else
		call proto_to_def#def_to_proto_paste(a:register)
	endif
endfu
"}}}
