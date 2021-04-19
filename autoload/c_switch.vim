" Returns the header name in the first #include \"...\" of the file
" If no result, return ''
" Stop searching after line 20

fu! c_switch#get_top_header_name()
	let save_pos = getcurpos()
	call cursor(1, 0)
	let header_line_number = search('^#include ".*"$', '', 20)
	if header_line_number == 0 | return '' | endif
	let line = getline(header_line_number)
	let header_filename = matchstr(line, '"\zs.*\ze"')
	call setpos('.', save_pos)
	return header_filename
endfu

" Expands :git: to the top level dir if present in a string
fu! s:expand_prefix(prefix)
	if match(a:prefix, ':git:') != -1
		let git_top_level = system("git rev-parse --show-toplevel 2>/dev/null | tr -d '\\n' ")
		if git_top_level == '' | return '' | endif
		return substitute(a:prefix, ':git:', git_top_level, '')
	else
		return (a:prefix)
	endif
endfu

" Search a file in a list of potential directories
" returns '' if no match
fu! s:find_file_in_dir_list(filename, dir_list)
	for prefix in a:dir_list
		let prefix = s:expand_prefix(prefix)
		if empty(prefix) || !isdirectory(prefix) | continue | endif
		return findfile(a:filename, prefix)
		" let file_path = prefix . '/' . a:filename
		" if filereadable(file_path)
		" 	return (file_path)
		" endif
	endfor
	return ('')
endfu

" Returns the first valid location, current dir otherwise
fu! s:prefered_location(dir_list)
	for dir in a:dir_list
		let dir = s:expand_prefix(dir)
		if !empty(dir) && isdirectory(dir) | return (dir) | endif
	endfor
	return ('.')
endfu

fu! s:find_and_edit_file(filename, dir_list)
	let file_path = s:find_file_in_dir_list(a:filename, a:dir_list)
	if empty(file_path)
		let prefered_location = s:prefered_location(a:dir_list)
		let file_path = prefered_location . '/' . a:filename
	endif
	exe 'e ' . simplify(file_path)
	return (file_path)
endfu

" Edit header
fu! c_switch#go_to_header()
	let header_name = c_switch#get_top_header_name()
	if empty(header_name)
		echohl WarningMsg | echo "You need to reference a to a header in this file." | echohl None
		return
	endif
	let implementation_file = expand('%')
	call s:find_and_edit_file(header_name, g:header_location)
	let b:implementation_file = implementation_file
endfu

" Insert gtest and local header
fu! s:insert_test_headers(header, is_c_type)
	let lnum = line('$') - 1
	call append(lnum, [ "#include <gtest/gtest.h>", "" ]) | let lnum += 2
	if a:is_c_type | call append(lnum, 'extern "C" {') | let lnum += 1 | endif
	call append(lnum, '#include "'.a:header.'"') | let lnum += 1
	if a:is_c_type | call append(lnum, '}') | endif
endfu

fu! c_switch#test_boilerplate(header, is_c_type)
	if search('#include') | return | endif
	call s:insert_test_headers(a:header, a:is_c_type)
endfu

" Edit test file
fu! c_switch#go_to_test_file()
	let test_filename = 'test_' . expand('%:t:r') . '.cc'
	let header = c_switch#get_top_header_name()
	let implementation_file = expand('%')
	call s:find_and_edit_file(test_filename, g:test_location)
	call c_switch#test_boilerplate(header, fnamemodify(implementation_file, ':e') == 'c')
	let b:implementation_file = implementation_file
endfu

" Edit cmake file
fu! c_switch#go_to_cmake_file()
	let folder=expand('%:p:h')
	while !empty(folder) && folder != '/'
		let try_file = folder . '/' . 'CmakeLists.txt'
		if filereadable(try_file)
			exe 'e ' . try_file
			return
		else
			let folder = fnamemodify(folder, ':h')
		endif
	endwhile
endfu
