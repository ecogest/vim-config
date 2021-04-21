" Returns a list of string
fu! s:hpp_template (name)
  let ret = [
        \ 'class '.a:name.' {',
        \ 'public:',
        \ '};',
        \ ''
        \ ]
  return ret
endfu

fu! hpp_template#insert_hpp_template (line, name)
  call append(line(a:line), s:hpp_template(a:name))
  call cursor(searchpos(a:name))
endfu
