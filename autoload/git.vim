" From: https://gist.github.com/actionshrimp/6493611
function! git#ToggleGStatus()
    if buflisted(bufname('.git/index'))
        if bufname('%') == bufname('git/index') | wincmd p | endif
        bd .git/index
    else
        Git
    endif
endfunction
