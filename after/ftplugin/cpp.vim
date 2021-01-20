" if exists("b:my_plugin")
"   finish
" endif

" Behaves just like C
runtime! ftplugin/c.vim 

" Protect my headers {{{
"
fu! s:protect_header ()
	call setline(1, '#ifndef ' . toupper(expand('%:r')) . '_H')
	call setline(2, '#endif')
    Stdheader
endfu

fu! s:check_filename (lnum)
  let fmt_name = split(a:lnum)[1]
  if fmt_name == toupper(expand('%:r') . '_H')
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
    let l:match = match(l:line, '#ifndef [[:upper:]_]\+_H$')
    if l:match != -1
      if s:check_filename(l:line) == 0
        call setline(i, '#ifndef ' . toupper(expand('%:r')) . '_H')
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
