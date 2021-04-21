fu! header42#protect_new_header ()
	let b:protect_id = toupper(expand('%:t:r')) . '_' . toupper(expand('%:e'))
	call setline(1, ['#ifndef '.b:protect_id, '# define '.b:protect_id, '', '#endif'])
	call cursor(3, 0)
	Stdheader
endfu

fu! s:is_valid_protection (protection_line)
	let protect_id = split(a:protection_line)[1] " #ifndef [protect_id]
	return protect_id == b:protect_id
endfu

fu! header42#update_header_protection ()
	let b:protect_id = toupper(expand('%:t:r')) . '_' . toupper(expand('%:e'))
	let lnum = 1
	let last_lnum = line("$")
	while lnum < last_lnum
		let l:line = getline(lnum)
		if l:line =~ '#ifndef [[:upper:]_]\+_H\(PP\)\=$'
			if !s:is_valid_protection(l:line)
				call setline(lnum, '#ifndef ' . b:protect_id)
				call setline(lnum + 1, '# define ' . b:protect_id)
			endif
			return
		endif
		let lnum += 1
	endwhile
endfu
