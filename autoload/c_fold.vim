let s:fold=0
let s:nestlvl=0

" Fold test_functions {{{1
fu! c_fold#fold_test_functions(lnum)
	let line=getline(a:lnum)
	" Start:
	let test_func_pattern='^\w\+\s\+test_\w\+(.*[^;]$'
	if (line =~ test_func_pattern)
		if (line =~ '{$') | let s:nestlvl+=1 | endif
		let s:fold_test=1
		return ('>1')
	" Middle:
	elseif s:fold_test == 1
		if (line =~ '{$')
			let s:nestlvl+=1
		elseif (line =~ '}$')
			let s:nestlvl-=1
			" End:
			if s:nestlvl == 0
				let s:fold_test=0
				return ('<1') " end
			endif
		endif
		return (1) " middle
	endif
	return (-1)
endfu

" 42 Header {{{1
fu! Has42Header()
	if get(b:, 'header42', 0) == 1
		return (1)
	endif
	if line('$') < 11
		return (-1)
	endif
	if getline(6) !~ '..\s\+By:' || getline(8) !~ '..\s\+Created'
		return (-1)
	else
		let b:has42header = 1
		return (1)
	endif
endfu

fu! c_fold#foldheader(lnum)
	if a:lnum >= 12 || !Has42Header()
		return (-1)
	endif
	if a:lnum == 1
		return ('>1')
	elseif a:lnum < 11
		return (1)
	else
		return ('<1')
	endif
endfu

" }}}
" Fold comments{{{
fu! c_fold#fold_comment(lnum)
	let line = getline(a:lnum)
	let begin = (line =~ '/\*')
	let end = (line =~ '\*/')
	if begin && !end
		return ('>1')
	elseif end && !begin
		return ('<1')
	" Mutli single-line /* ... */
	elseif begin && end
		if a:lnum > 1 && a:lnum < line('$')
			let prev = (getline(a:lnum - 1) =~ '^\s*/\*.*\*/$')
			let next = (getline(a:lnum + 1) =~ '^\s*/\*.*\*/$')
			if !prev && next
				return ('>1')
			elseif prev && !next
				return ('<1')
			else
				return (-1)
			endif
		endif
	else
		return (-1)
	endif
endfu
"}}}

" Main fold function:

fu! c_fold#c_fold(lnum)
	" Header
	let ret = c_fold#foldheader(a:lnum)
	if ret != -1 | return ret | endif
	" Comments
	let ret = c_fold#fold_comment(a:lnum)
	if ret != -1 | return ret | endif
	" Test functions
	let ret = c_fold#fold_test_functions(a:lnum)
	if ret != -1 | return ret | endif
	" Else
	return -1
endfu
