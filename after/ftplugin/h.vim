" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Behaves just like C
runtime! ftplugin/c.vim 

fu! s:protect ()
	call setline(1, '#ifndef ' . toupper(expand('%:h')). '_H')
endfu

command! Hprotect call s:protect()
au BufNewFile * call s:protect()
