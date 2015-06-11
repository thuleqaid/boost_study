" Name    : GuiFont
" Object  : Switch guifont quickly
" Author  : thuleqaid@163.com
" Date    : 2015/06/10
" Version : v0.1
" ChangeLog
" v0.1 2015/06/10
"   add s:SumModifiedLines()
"   add s:GenerateCommand()

" Usage :
" 1. use <Leader>fl to display the font list
" 2. use <Leader>fn/fp to switch to next/previous font in the list
" 3. use N<Leader>fs to set font in the list by index N
" Config :
" 1. set g:guifontlist in the .vimrc
" 2. set guifont in the .vimrc
"   example:
"   let g:guifontlist = ['Fixedsys:h12:cGB2312', 'MS_Gothic:h12:cSHIFTJIS', '楷体:h12:cGB2312']
"   set guifont=Fixedsys:h12:cGB2312
" FontName :
" 1. :set guifont=*
" 2. choose a font by gui
" 3. :echo &guifont

" Parameter
let g:guifontlist = get(g:, 'guifontlist', ['Fixedsys:h12:cGB2312', 'MS_Gothic:h12:cSHIFTJIS'])

" Key bindings
command! -n=0 -bar GuiFontListList :call s:ListGuifont()
command! -n=0 -bar GuiFontListNext :call s:SwitchGuifont(1, 1)
command! -n=0 -bar GuiFontListPrev :call s:SwitchGuifont(1, -1)
command! -n=0 -count -bar GuiFontListSet :call s:SwitchGuifont(2, <count>)

nmap <Leader>fl :GuiFontListList<CR>
nmap <Leader>fn :GuiFontListNext<CR>
nmap <Leader>fp :GuiFontListPrev<CR>
nmap <Leader>fs :GuiFontListSet<CR>

" functions
function! s:ListGuifont()
	let l:i = 0
	let l:outstr = ''
	let l:curidx = s:curfontidx()
	while l:i < len(g:guifontlist)
		if l:i == l:curidx
			let l:outstr = l:outstr . '* ' . l:i . ":\t" . g:guifontlist[l:i] . "\n"
		else
			let l:outstr = l:outstr . '  ' . l:i . ":\t" . g:guifontlist[l:i] . "\n"
		endif
		let l:i = l:i + 1
	endwhile
	echo l:outstr
endfunction
function! s:SwitchGuifont(type, val)
	echo a:type a:val
	if a:type == 1
		" 相对index
		let l:curidx = s:curfontidx()
	elseif a:type == 2
		" 绝对index
		let l:curidx = 0
	endif
	let l:curidx = l:curidx + a:val
	let l:nextidx = s:modulus(l:curidx, len(g:guifontlist))
	" g:guifontlist为空时，s:modulus返回0
	if l:nextidx < len(g:guifontlist)
		silent! exe 'set guifont=' . g:guifontlist[l:nextidx]
	endif
endfunction

function! s:modulus(divident, divisor)
	let l:ret = a:divident % a:divisor
	let l:ret = (l:ret + a:divisor) % a:divisor
	return l:ret
endfunction
function! s:curfontidx()
	let l:curfont = &guifont
	let l:curidx = index(g:guifontlist, l:curfont)
	return l:curidx
endfunction

