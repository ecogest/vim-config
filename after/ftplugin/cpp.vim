" if exists("b:my_plugin")
"   finish
" endif

" Behaves just like C
runtime! ftplugin/c.vim 

" Protect my headers {{{
"
fu! s:protect_header ()
	call setline(1, '#ifndef ' . toupper(expand('%:t:r')) . '_H')
	call setline(2, '#endif')
    Stdheader
endfu

fu! s:check_filename (lnum)
  let protect_id = split(a:lnum)[1]
  if protect_id == toupper(expand('%:r') . '_H')
    return 1
  else
    return 0
  endif
endfu

fu! s:update_header ()
  let i = 1
  let nlines = line("$")
  while i < nlines
    let l:line = getline(i)
    if l:line =~ '#ifndef [[:upper:]_]\+_H$'
      if s:check_filename(l:line) == 0
        call setline(i, '#ifndef ' . toupper(expand('%:t:r')) . '_H')
      endif
      return
    endif
    let i += 1
  endwhile
endfu

command! Hprotect call s:protect_header()
command! Hupdate call s:update_header()
au BufWritePre *.h Hupdate
" in vimrc you should put:
" au BufNewFile *.h Hprotect

"}}}
