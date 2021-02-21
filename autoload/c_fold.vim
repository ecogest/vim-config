let s:fold=0
let s:nestlvl=0

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

fu! c_fold#c_fold(lnum)
	return c_fold#fold_test_functions(a:lnum)
endfu
