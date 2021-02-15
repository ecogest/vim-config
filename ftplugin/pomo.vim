" Options {{{1
setl et
setl conceallevel=1
setl concealcursor=n
setl nu norelativenumber

" Parameters {{{1
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['pomo'] = '🍅'

if !exists('g:track_dir')
  let g:track_dir=$HOME.'/.trackdir'
endif

" Mappings {{{1
nnoremap <silent><buffer> x :PomoCheck <bar> w<CR>
nnoremap <silent><buffer> <localleader>a :<C-U>call pomo#AddFromDailyList()<CR>
