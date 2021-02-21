" if exists("b:my_plugin")
"   finish
" endif

" Behaves just like C
runtime! ftplugin/c.vim

" Protect my headers {{{
"

let s:protect_id = toupper(expand('%:t:r')) . '_H'

fu! s:protect_header ()
  call setline(1, '#ifndef ' . s:protect_id)
  call setline(2, '# define ' . s:protect_id)
  call setline(3, '#endif')
  Stdheader
endfu

fu! s:check_filename (line)
  let protect_id = split(a:line)[1]
  if protect_id == s:protect_id
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
        call setline(i, '#ifndef ' . s:protect_id)
        call setline(i + 1, '# define ' . s:protect_id)
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
