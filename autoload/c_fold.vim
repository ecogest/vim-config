let s:fold=0
let s:nestlvl=0

" Fold test_functions {{{1
fu! c_fold#fold_test_functions(lnum)
	let line=getline(a:lnum)
	let test_func_pattern='^\w\+\s\+test_\w\+('
	if (line =~ test_func_pattern)
		let s:fold=1
		return (1)
	elseif s:fold == 1
		if (line =~ '{$')
			let s:nestlvl+=1
		elseif (line =~ '}$')
			let s:nestlvl-=1
			if s:nestlvl == 0
				let s:fold=0
				return (1)
			endif
		endif
		return (1)
	endif
	return (0)
endfu

" 42 Header {{{1
fu! Has42Header()
	if get(b:, 'header42', 0) == 1
		return (1)
	endif
	if line('$') < 11
		return (0)
	endif
	if getline(6) !~ '..\s\+By:' || getline(8) !~ '..\s\+Created'
		return (0)
	else
		let b:has42header = 1
		return (1)
	endif
endfu

fu! c_fold#foldheader(lnum)
	if a:lnum <= 11 && Has42Header()
		return 1
	else
		return 0
	endif
endfu

" }}}

" Main fold function:

fu! c_fold#c_fold(lnum)
	let ret = c_fold#foldheader(a:lnum)
	if ret
		return ret
	endif
	return c_fold#fold_test_functions(a:lnum)
endfu
