" Init{{{
if exists('g:loaded_pretty_header')
  finish
endif

let g:loaded_pretty_header = 1
"}}}

" Commands {{{

command! -nargs=1 PrettyHeader call pretty_header#pretty_header(<f-args>)
" }}}
