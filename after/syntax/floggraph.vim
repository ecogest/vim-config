syn match flogDateRel '(\d \w\+ ago)' containedin=ALL
syn match flogBar '|' containedin=ALL
hi def link flogDateRel Comment
hi def link flogBar Comment
hi def link flogMessage FlogDate
syn match flogMessage '| .*$' containedin=ALL
