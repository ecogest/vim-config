setl et
setl conceallevel=1
setl concealcursor=n
setl nu norelativenumber
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['pomo'] = '🍅'
nnoremap <silent><buffer> x :PomoCheck <bar> w<CR>
nnoremap <silent><buffer> <localleader>a :<C-U>call AddFromDailyList()<CR>
