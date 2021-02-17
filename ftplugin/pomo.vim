" Options {{{1
setl et
setl conceallevel=1
setl concealcursor=n
setl nu norelativenumber

" Global Parameters {{{1
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['pomo'] = '🍅'

if !exists('g:track_dir')
  let g:track_dir=$HOME.'/.trackdir'
endif

if !exists('g:pomo_file_name')
  let g:pomo_file_name='daily.pomo'
endif
if !exists('g:pomo_todo_file')
  let g:pomo_todo_file=g:track_dir.'/todo.pomo'
endif
if !exists('g:pomo_symbol')
  let g:pomo_symbol=''
endif
if !exists('g:pomo_todo_symbol')
  let g:pomo_todo_symbol='' "  
endif
if !exists('g:pomo_brief_symbol')
  let g:pomo_brief_symbol=''
endif
if !exists('g:pomo_done_symbol')
  let g:pomo_done_symbol=''
endif
if !exists('g:pomo_empty_symbol')
  let g:pomo_empty_symbol=''
endif

" Mappings {{{1
nnoremap <silent><buffer> x :<C-U>PomoCheck <bar> w<CR>
nnoremap <silent><buffer><expr> a (v:count == 0 ? 'a': ':<C-U>call pomo#AddFromDailyList()<CR>')
