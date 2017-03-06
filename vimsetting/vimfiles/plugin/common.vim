command! -nargs=1 Utf8Code :call s:comUtf8Code("<args>")
let s:Utf8TextPrefix = '#utf8#'
let s:Utf8TextPrefixLen = strlen(s:Utf8TextPrefix)

function! Utf8TextPrefix()
	return s:Utf8TextPrefix
endfunction

function! Utf8Text(data)
	if s:testUtf8Code(a:data) > 0
		let l:txt = iconv(strpart(a:data,s:Utf8TextPrefixLen), 'utf-8', &enc)
	else
		let l:txt = a:data
	endif
	return l:txt
endfunction

function! Utf8Code(data)
	" save current encoding
	let l:curenc = &encoding
	" change input text into utf-8 encoding
	let l:u8data = iconv(a:data, l:curenc, 'utf-8')
	" open a temp buffer
	silent exe 'enew'
	silent exe 'set encoding=utf-8'
	call setline(1, l:u8data)
	silent exe '%!xxd -ps'
	silent exe 'normal gg' . repeat('Jx', line('$'))
	let l:hexdata = getline(1)
	let l:hexlen  = strlen(l:hexdata)
	" strip line break
	if &fileformat == 'dos'
		call setline(1, strpart(l:hexdata,0,l:hexlen-4))
	else
		call setline(1, strpart(l:hexdata,0,l:hexlen-2))
	endif
	" add '\x' in front of each byte
	silent exe 's/.\{2}/\\x\0/g'
	" copy result into register u
	silent exe 'normal v$h"uy'
	let l:hexdata = getline(1)
	" delete temp buffer
	silent exe 'bd!'
	" restore encoding
	silent exe 'set encoding=' . l:curenc
	return l:hexdata
endfunction

function! ListAndSelect(title, itemlist, markindex)
	let l:choices = copy(a:itemlist)
	" generate choice-list
	call map(l:choices, '"  " . (v:key + 1) . ". " . v:val')
	" insert '*' at the start of selected item
	if (a:markindex >= 0) && (a:markindex < len(a:itemlist))
		let l:choices[a:markindex] = '*' . l:choices[a:markindex][1:]
	endif
	" set list title
	call insert(l:choices, a:title)
	" ask for user choice
	let l:choice = inputlist(l:choices)
	if (l:choice < 1) || (l:choice > len(a:itemlist))
		let l:choice = 0
	endif
	return l:choice - 1
endfunction

function! s:comUtf8Code(data)
	let l:curpos = getpos('.')
	let l:hexdata = Utf8Code(a:data)
	call setpos('.', l:curpos)
	silent exe 'normal "up'
endfunction

function! s:testUtf8Code(data)
	let l:prefix = strpart(a:data, 0, s:Utf8TextPrefixLen)
	if l:prefix == s:Utf8TextPrefix
		let l:ret = 1
	else
		let l:ret = 0
	endif
	return l:ret
endfunction
