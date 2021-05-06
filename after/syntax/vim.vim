" Various global syntax options:
" syn include <sfile>:p:h/global.vim " does the same
runtime! syntax/global.vim

syn keyword vimPlug Plug
hi! def link vimPlug vimCommand
