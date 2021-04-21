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

fu! s:snake_to_camel (str)
  let camel_str = substitute(a:str, '\w', '\U&', '')
  return substitute(camel_str, '\v_(\w)', '\U\1', 'g')
endfu

fu! hpp_template#insert_hpp_template (line, name)
  let camel_name = s:snake_to_camel(a:name)
  call append(line(a:line), s:hpp_template(camel_name))
  call cursor(searchpos(camel_name))
endfu

