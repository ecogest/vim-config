" if exists("b:my_plugin")
"   finish
" endif

" Behaves just like C
runtime! ftplugin/c.vim

" Protect my headers {{{
"

fu! s:protect_new_header ()
  let b:protect_id = toupper(expand('%:t:r')) . '_H'
  call setline(1, '#ifndef ' . b:protect_id)
  call setline(2, '# define ' . b:protect_id)
  call setline(3, '')
  call setline(4, '#endif')
  call cursor(3, 0)
  Stdheader
endfu

fu! s:is_valid_protection (protection_line)
  let protect_id = split(a:protection_line)[1] " #ifndef [protect_id]
  return protect_id == b:protect_id
endfu

fu! s:update_header_protection ()
  let b:protect_id = toupper(expand('%:t:r')) . '_H'
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
au BufWritePre *.h Hupdate
" in vimrc you should put:
" au BufNewFile *.h Hprotect

"}}}
