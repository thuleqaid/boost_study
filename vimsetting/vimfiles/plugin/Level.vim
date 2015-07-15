" define command
command! -n=0 -rang=% -bar LvlDraw :<line1>,<line2>call s:LvlDraw()

let s:mark0  = '    '
if &encoding == 'utf-8'
	" utf-8
	let s:mark1  = '┣━'
	let s:mark2  = '┃  '
	let s:mark3  = '┗━'
else
	" cp936
	let s:mark1  = iconv("\xe2\x94\xa3\xe2\x94\x81", "utf-8", &enc)
	let s:mark2  = iconv("\xe2\x94\x83", "utf-8", &enc) . '  '
	let s:mark3  = iconv("\xe2\x94\x97\xe2\x94\x81", "utf-8", &enc)
endif
let s:indent = '	'

function! s:LvlDraw() range
	let l:levels = s:calcLevels(a:firstline, a:lastline)
	let l:indent = len(s:indent)
	let l:i      = a:firstline
	while l:i <= a:lastline
		if l:levels[l:i - a:firstline][0] < 0
			" empty line
			call setline(l:i, l:levels[l:i - a:firstline][1])
		else
			call setline(l:i, l:levels[l:i - a:firstline][1] . strpart(getline(l:i), l:indent * l:levels[l:i - a:firstline][0]))
		endif
		let l:i = l:i + 1
	endwhile
endfunction

function! s:calcLevels(linestart, linestop)
	let l:result = []
	let l:i      = a:linestart
	while l:i <= a:linestop
		let l:parts = split(getline(l:i), s:indent, 1)
		let l:cnt   = 0
		while l:parts[l:cnt] == ''
			let l:cnt = l:cnt + 1
			if l:cnt >= len(l:parts)
				break
			endif
		endwhile
		call add(l:result, (l:cnt>=len(l:parts))?-1:l:cnt)
		let l:i = l:i + 1
	endwhile
	let l:result2 = []
	let l:maxi    = a:linestop - a:linestart + 1
	let l:i       = 0
	while l:i < l:maxi
		let l:val = l:result[0]
		call remove(l:result, 0)
		let l:tmp = s:calcMarks(l:result, l:val)
		let l:prefix = ''
		for l:element in l:tmp
			if l:element == 0
				let l:prefix = l:prefix . s:mark0
			elseif l:element == 1
				let l:prefix = l:prefix . s:mark1
			elseif l:element == 2
				let l:prefix = l:prefix . s:mark2
			elseif l:element == 3
				let l:prefix = l:prefix . s:mark3
			endif
		endfor
		call add(l:result2, [l:val, l:prefix])
		let l:i = l:i + 1
	endwhile
	return l:result2
endfunction
function! s:calcMarks(lvlarray, val)
	let l:result = []
	let l:val = a:val
	if l:val < 0
		let l:i = 0
		while l:i < len(a:lvlarray)
			if a:lvlarray[l:i] >= 0
				let l:val = a:lvlarray[l:i]
				break
			endif
			let l:i = l:i + 1
		endwhile
		if l:val < 0
			return l:result
		endif
	endif
	let l:i      = 1
	while l:i <= l:val
		let l:k = (l:i == l:val)?3:0
		let l:j = 0
		while l:j < len(a:lvlarray)
			if a:lvlarray[l:j] == l:i
				let l:k = (l:i == l:val)?1:2
				break
			elseif (a:lvlarray[l:j] >= 0) && (a:lvlarray[l:j] < l:i)
				let l:k = (l:i == l:val)?3:0
				break
			endif
			let l:j = l:j + 1
		endwhile
		if (l:k == 1) && (a:val < 0)
			let l:k = 2
		endif
		call add(l:result, l:k)
		let l:i = l:i + 1
	endwhile
	return l:result
endfunction

