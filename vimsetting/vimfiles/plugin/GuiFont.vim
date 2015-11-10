" Name    : GuiFont
" Object  : Switch guifont quickly
" Author  : thuleqaid@163.com
" Date    : 2015/11/09
" Version : v0.4
" ChangeLog
" v0.4 2015/11/09
"   move s:ListAndSelect into common.vim
" v0.3 2015/08/01
"   add s:ListEncoding()
" v0.2 2015/06/27
"   add s:ListAndSelect()
"   modify s:ListGuifont() to allow choose from list
" v0.1 2015/06/10
"   new plugin

" Usage :
" 1. use <Leader>fl to display the font list
" 2. use <Leader>fn/fp to switch to next/previous font in the list
" 3. use N<Leader>fs to set font in the list by index N
" 4. use <Leader>el to select encoding
" Config :
" 1. set g:guifontlist in the .vimrc
" 2. set guifont in the .vimrc
" 3. set g:encodinglist in the .vimrc
" 4. set encoding in the .vimrc
"   example:
"   let g:guifontlist = ['Fixedsys:h12:cGB2312', 'MS_Gothic:h12:cSHIFTJIS', '楷体:h12:cGB2312']
"   exe 'set guifont=' . g:guifontlist[0]
"   let g:encodinglist = ['utf-8','cp932','cp936']
"   exe 'set encoding=' . g:encodinglist[0]
" FontName :
" 1. :set guifont=*
" 2. choose a font by gui
" 3. :echo &guifont

" Parameter
let g:guifontlist = get(g:, 'guifontlist', ['',])
let g:encodinglist = get(g:, 'encodinglist', [['utf-8',''], ['cp932', ''], ['cp936', '']])

" Key bindings
command! -n=0 -bar GuiFontEncodingList :call s:ListEncoding()
command! -n=0 -bar GuiFontListList :call s:ListGuifont()
command! -n=0 -bar GuiFontListNext :call s:SwitchGuifont(1, 1)
command! -n=0 -bar GuiFontListPrev :call s:SwitchGuifont(1, -1)
command! -n=0 -count -bar GuiFontListSet :call s:SwitchGuifont(2, <count>-<line1>)

nmap <Leader>el :GuiFontEncodingList<CR>
nmap <Leader>fl :GuiFontListList<CR>
nmap <Leader>fn :GuiFontListNext<CR>
nmap <Leader>fp :GuiFontListPrev<CR>
nmap <Leader>fs :GuiFontListSet<CR>

" functions
function! s:ListEncoding()
	let l:encodinglist = map(copy(g:encodinglist), 'v:val[0]')
	let l:curidx = index(l:encodinglist, &encoding)
	let l:newidx = ListAndSelect('Encoding List:', l:encodinglist, l:curidx)
	if (l:newidx >= 0)
		silent! exe 'set encoding=' . g:encodinglist[l:newidx][0]
		if strlen(g:encodinglist[l:newidx][1]) > 0
			silent! exe 'set guifont=' . g:encodinglist[l:newidx][1]
		endif
	endif
endfunction
function! s:ListGuifont()
	let l:curidx = s:curfontidx()
	let l:newidx = ListAndSelect('Font List:', g:guifontlist, l:curidx)
	if (l:newidx >= 0) && (l:newidx != l:curidx)
		silent! exe 'set guifont=' . g:guifontlist[l:newidx]
	endif
endfunction
function! s:SwitchGuifont(type, val)
	if a:type == 1
		" 相对index
		let l:curidx = s:curfontidx() + a:val
	elseif a:type == 2
		" 绝对index
		if a:val > 0
			let l:curidx = a:val
		else
			let l:curidx = 0
		endif
	endif
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
