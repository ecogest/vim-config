" From: https://gist.github.com/actionshrimp/6493611
function! git#ToggleGStatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction
