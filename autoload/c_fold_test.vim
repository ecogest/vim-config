let s:fold=0
let s:foldlevel=0

fu! c_fold_test#fold_test_functions(lnum)
	let line=getline(a:lnum)
	let test_func_pattern='^\w\+\s\+test_\w\+('
	if (line =~ test_func_pattern)
		let s:fold=1
		return (1)
	elseif s:fold == 1
		if (line =~ '^\s*{')
			let s:foldlevel+=1
		elseif (line =~ '^\s*}')
			let s:foldlevel-=1
			if s:foldlevel == 0
				let s:fold=0
				return 1
			endif
		endif
		return (1)
	endif
	return (0)
endfu
