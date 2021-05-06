" Private functions {{{

" Expands :git: to the top level dir if present in a string
fu! s:expand_prefix(prefix)
	if match(a:prefix, ':git:') != -1
		let git_top_level = system("git rev-parse --show-toplevel 2>/dev/null | tr -d '\\n' ")
		if git_top_level == '' | return '' | endif
		return simplify(substitute(a:prefix, ':git:', git_top_level, ''))
	else
		return simplify((a:prefix))
	endif
endfu

fu! s:join_path(head, tail)
	return (simplify(join([a:head, a:tail], '/')))
endfu

" Returns the list of existing directories with the target name from the
" source location up to the root dir
fu! s:list_possible_directories(source_location, root_dir, target_dir_names)
	let list = []
	let current_dir = a:source_location
	while v:true
		for dir in a:target_dir_names
			let target = s:join_path(current_dir, dir)
			if isdirectory(target)
				let list = add(list, target)
			endif
		endfor
		if current_dir == a:root_dir || current_dir == '/'
			return list
		else
			let current_dir = fnamemodify(current_dir, ':h')
		endif
	endwhile
endfu

fu! s:find_file(target_name, root_dir, possible_directories, source_location)
	" First we search the target in the current dir (not recursively)
	let target_path = s:join_path(a:source_location, a:target_name)
	if filereadable(target_path) | return target_path | endif
	" Then we list all matching directories from the source location up too the
	" root dir
	let dir_list = s:list_possible_directories(a:source_location, a:root_dir, a:possible_directories)
	if empty(dir_list) | return '' | endif
	" In each dir we check if the target file already exists
	for dir in dir_list
		let target_path = findfile(a:target_name, dir)
		if !empty(target_path) | return target_path | endif
	endfor
	" If no file is found, we will create one where the first directory match
	" happened
	return s:join_path(dir_list[0], a:target_name)
endfu

" The root dir will be the first dir to already exist in the given list
fu! s:resolve_root_dir(root_directories)
	for dir in a:root_directories
		let dir = s:expand_prefix(dir)
		if isdirectory(dir) | return dir | endif
	endfor
	return ''
endfu

fu! s:go_to(target_name, possible_directories)
	let implementation_file = expand('%:p')
	let source_location = expand('%:p:h')
	let root_dir = s:resolve_root_dir(g:root_directories)
	let target_path = s:find_file(a:target_name, root_dir, a:possible_directories, source_location)
	if empty(target_path)
		let target_path = s:join_path(source_location, a:target_name)
	endif
	exe 'e ' . target_path
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

" Returns path of the closest CmakeLists.txt in upper directories
fu! s:get_cmakelists_path()
	let folder=expand('%:p:h')
	while !empty(folder) && folder != '/'
		let try_file = folder . '/' . 'CmakeLists.txt'
		if filereadable(try_file)
			return try_file
		else
			let folder = fnamemodify(folder, ':h')
		endif
	endwhile
endfu

" Returns the line where to insert the source. If source already listed,
" returns 0
fu! s:should_insert_src_in_cmakelists_at(cmake_file_list_lines, current_file_relative_path)
	let lnum = 1
	for line in a:cmake_file_list_lines
		if line =~# a:current_file_relative_path
			return 0
		endif
		if line =~ 'set (\(TEST_\)\=SRCS$'
			" se rappeler de la ligne
			let src_lnum = lnum
		endif
		let lnum += 1
	endfor
	return src_lnum + 1
endfu

" }}}

" Public functions {{{

" Returns the header name in the first #include \"...\" of the file
" If no result, return ''
" Stop searching after line 20
fu! c_switch#get_top_header_name()
	let save_pos = getcurpos()
	call cursor(1, 1)
	let header_line_number = search('^\s*#\s*include ".*"', 'c', 20)
	if header_line_number == 0 | return '' | endif
	let line = getline(header_line_number)
	let header_filename = matchstr(line, '"\zs.*\ze"')
	call setpos('.', save_pos)
	return header_filename
endfu

" Insert googletest boilerplate if no header yet found
fu! c_switch#test_boilerplate(header, is_c_type)
	if search('#include') | return | endif
	call s:insert_test_headers(a:header, a:is_c_type)
endfu

" Edit header
fu! c_switch#go_to_header()
	let header_name = c_switch#get_top_header_name()
	if empty(header_name)
		echohl WarningMsg | echo "You need to reference to a header in this file." | echohl None
		return
	endif
	call s:go_to(header_name, g:header_directories)
endfu

" Edit test file
fu! c_switch#go_to_test_file()
	let test_filename = 'test_' . expand('%:t:r') . '.cc'
	let header = c_switch#get_top_header_name()
	let implementation_file = expand('%:p')
	call s:go_to(test_filename, g:test_directories)
	call c_switch#test_boilerplate(header, fnamemodify(implementation_file, ':e') == 'c')
endfu

" Edit cmake file
fu! c_switch#go_to_cmake_file()
	let implementation_file = expand('%:p')
	let cmake_file = s:get_cmakelists_path()
	exe 'e ' . cmake_file
	let b:implementation_file = implementation_file
endfu

fu! c_switch#add_current_file_to_cmakelists()
	let cmakelists_directory = fnamemodify(s:get_cmakelists_path(), ':h:p')
	let backup_current_dir = getcwd()
	exe 'chdir ' . cmakelists_directory
	let current_file_relative_path = expand('%')
	let cmakelists_lines = readfile('CmakeLists.txt')
	let should_insert_src_at = s:should_insert_src_in_cmakelists_at(cmakelists_lines, current_file_relative_path)
	if !should_insert_src_at
		echo 'Source already in CmakeLists.txt'
	else
		call insert(cmakelists_lines, '  ' . current_file_relative_path, should_insert_src_at)
		echo 'Source added to CmakeLists.txt'
		call writefile(cmakelists_lines, 'CmakeLists.txt')
	endif
	exe 'chdir ' . backup_current_dir
endfu
" }}}
