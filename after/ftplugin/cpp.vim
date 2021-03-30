" if exists("b:my_plugin")
"   finish
" endif

" Behaves just like C
runtime! ftplugin/c.vim

" Protect my headers {{{
"

fu! s:protect_new_header ()
  let b:protect_id = toupper(expand('%:t:r')) . '_' . toupper(expand('%:e'))
  call setline(1, ['#ifndef '.b:protect_id, '# define '.b:protect_id, '', '#endif'])
  call cursor(3, 0)
  Stdheader
endfu

fu! s:is_valid_protection (protection_line)
  let protect_id = split(a:protection_line)[1] " #ifndef [protect_id]
  return protect_id == b:protect_id
endfu

fu! s:update_header_protection ()
  let b:protect_id = toupper(expand('%:t:r')) . '_' . toupper(expand('%:e'))
  let lnum = 1
  let last_lnum = line("$")
  while lnum < last_lnum
    let l:line = getline(lnum)
    if l:line =~ '#ifndef [[:upper:]_]\+_H$'
      if !s:is_valid_protection(l:line)
        call setline(lnum, '#ifndef ' . b:protect_id)
        call setline(lnum + 1, '# define ' . b:protect_id)
      endif
      return
    endif
    let lnum += 1
  endwhile
endfu

command! Hprotect call s:protect_new_header()
command! Hupdate call s:update_header_protection()
au BufWritePre *.h *.hpp Hupdate
" in vimrc you should put:
" au BufNewFile *.h Hprotect

"}}}
" Hpp template {{{
"
" Returns a list of string
fu! s:hpp_template (name)
  let ret = [
        \ 'class '.a:name.' {',
        \ 'private:',
        \ 'public:',
        \ "\t".a:name.'();',
        \ "\t~".a:name.'();',
        \ 'protected:',
        \ '};',
        \ ''
        \ ]
  return ret
endfu

fu! s:snake_to_camel (str)
  let camel_str = substitute(a:str, '\w', '\U&', '')
  return substitute(camel_str, '\v_(\w)', '\U\1', 'g')
endfu

fu! s:insert_hpp_template (line, name)
  let camel_name = s:snake_to_camel(a:name)
  call append(line(a:line), s:hpp_template(camel_name))
  call cursor(searchpos(camel_name))
endfu

command! HppTemplate call s:insert_hpp_template('.', expand('%:t:r'))
" }}}
