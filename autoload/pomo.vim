" Script parameters {{{1
let s:pomo_line=g:pomo_symbol.' Pomo '
let s:pomo_todo_line=g:pomo_todo_symbol.' Todo'
let s:pomo_sub_todo_line=' '.s:pomo_todo_line
let s:pomo_brief_line=' '.g:pomo_brief_symbol.' Brief'

" Public functions {{{1

" automaticall insert ' - [ ] ' on some keys ('o' and 'O')
fu! pomo#autoStartItem(key, mode)
  let line = getline('.')
  if a:mode == 'n'
    exe 'normal!' . a:key
  elseif a:mode == 'a'
    exe 'normal! a'. a:key
  endif
  if line =~ '^ - ' && getline('.') =~ '^\s*$'
    call setline('.', ' - [ ] ')
  endif
  normal! $
  startinsert!
endfu

fu! pomo#AddFromDailyList()
  if v:count == 0
    return
  endif
  let task = getline(v:count)
  if getline('.') =~ '^ - \[ ] \=$'
    call setline('.', task)
  else
    call append('.', task)
    normal! j
  endif
  normal! $
endfu

fu! pomo#PomoReplaceDone()
  let cp = getcurpos()[1:2]
  silent %s/\[x]/\=g:pomo_done_symbol/e
  call cursor(cp)
endfu

fu! pomo#PomoMarkLineChecked()
  let cp = getcurpos()[1:2]
  if v:count == 0
    let done_line = getline('.')
  else
    let done_line = getline(v:count)
  endif
  call s:setLastPomoData()
  if s:pomo_count <= 1
    let range_end = line('$')
  else
    let range_end = search('^' . s:pomo_line . (s:pomo_count - 1) . '$')
  endif
  let l = 1
  while l <= range_end
    if getline(l) == done_line
      exe 'silent '.l.'s/^\s*- \[\zs \ze]/x/e'
      " sort
      let i = 1
      if l + i == line('$') | break | endif
      while getline(l + i) =~ '^ - '
        let i +=1
      endwhile
      if i > 1
        let l:line = getline('.')
        normal! dd
        call append(l + i - 2, l:line)
      endif
      " end sort
    endif
    let l += 1
  endwhile
  call cursor(cp)
endfu

fu! pomo#PomoSaveTodoList()
  let cp = getcurpos()[1:2]
  let is_todo = search('^'.s:pomo_todo_line.'$')
  call cursor(cp)
  if is_todo == 0 | return | endif
  0
  let first_pomo_section = search('^'.s:pomo_line.'\d\+$')
  let last_todo_line = first_pomo_section != 0 ? first_pomo_section - 1 : line('$')
  let lines = getline(is_todo, last_todo_line)
  call filter(lines, 'v:val !~ "^\\s*- " . g:pomo_done_symbol')
  call writefile(lines, g:pomo_todo_file)
  call cursor(cp)
endfu

fu! pomo#PomoTracker(category)
  call s:createTrackDir()
  call s:open_pomo_file()
  setf pomo
  if a:category == 'todo'
    call s:insertTodo()
    call s:goToLastTodo()
  elseif a:category == 'pomo'
    call s:insertPomo()
    call s:pomoReplaceEmpty()
  elseif a:category == 'brief'
    call s:goToBrief()
  endif
endfu

" Private {{{1
fu! s:pomoReplaceEmpty()
  normal mZ
  0
  let first_section = search('^\S Pomo \d\+$')
  let second_section = search('^\S Pomo \d\+$', 'W')
  if first_section == 0 || second_section == 0
    normal `Z
    return
  endif
  silent .,$s/\[ ]/\=g:pomo_empty_symbol/e
  normal `Z
endfu

fu! s:createTrackDir()
  let fw=filewritable(g:track_dir)
  if fw== 1
    call system('rm '.g:track_dir)
  endif
  call mkdir(g:track_dir, 'p')
  let s:daily_track_dir = join([g:track_dir, strftime('%Y'), strftime('%m'), strftime('%d')], '/')
  call mkdir(s:daily_track_dir, 'p')
endfu

fu! s:open_pomo_file()
  let l:pomo_path = s:daily_track_dir . '/' . g:pomo_file_name
  if expand('%') == l:pomo_path | return | endif
  exe 'tabe ' . l:pomo_path
endfu

fu! s:insertTodo()
  if getline(1) == s:pomo_todo_line
    return
  elseif filereadable(g:pomo_todo_file) && readfile(g:pomo_todo_file, '',1)[0] == s:pomo_todo_line
    exe '0r '.g:pomo_todo_file
    normal! Gdd\<C-O>
  else
    let todo_text = [
          \ s:pomo_todo_line,
          \ '',
          \ ' - [ ] '
          \ ]
    if len(getline('.')) != 0 | call extend(todo_text, ['']) | endif
    call append(0, todo_text)
  endif
endfu

" find last line of the todo section
fu! s:goToLastTodo()
  let lnum = 2
  while lnum <= line('$') && getline(lnum + 1) !~ '^'.s:pomo_line
    let lnum += 1
  endwhile
  while len(getline(lnum)) == 0
    let lnum -= 1
  endwhile
  exe lnum
  normal! $
endfu

" sets s:last_pomo_line and s:pomo_count
fu! s:setLastPomoData()
  exe 0
  let s:last_pomo_line = search('^'.s:pomo_line.'\d\+', 'c')
  if s:last_pomo_line != 0
    let s:pomo_count = matchstr(getline(s:last_pomo_line), '\d\+')
  else
    let s:pomo_count = 0
  endif
endfu

" write pomo section and todo subsection
fu! s:insertPomo()
  call s:setLastPomoData()
  let pomo_todo_text = [
        \ s:pomo_line . (s:pomo_count + 1),
        \ '',
        \  s:pomo_sub_todo_line,
        \ '',
        \ ' - [ ] ',
        \ '',
        \ s:pomo_brief_line
        \ ]
  if s:pomo_count == 0
    let insertion_lnum = line('$') == 1 ? 0 : line('$')
  else
    let insertion_lnum = s:last_pomo_line - 1
  endif
  if insertion_lnum > 0 && len(getline(insertion_lnum)) != 0
    call insert(pomo_todo_text, '')
  endif
  if s:pomo_count | call extend(pomo_todo_text, ['']) | endif
  call append(insertion_lnum, pomo_todo_text)
  call s:setLastPomoData()
  exe s:last_pomo_line
  call search(' - \[ ]')
  normal! $
  normal! zv$
endfu

fu! s:goToBrief()
  exe 0
  let target_line = search('^'.s:pomo_brief_line.'$')
  if target_line == 0 | return | endif
  exe target_line
  if target_line == line('$') || getline(target_line + 2) =~ '^'.s:pomo_line
    call append(line('.'), repeat([''], 2))
  endif
  exe line('.') + 2
endfu
