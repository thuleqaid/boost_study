let g:vimide_showmenu = get(g:, 'vimide_showmenu', 1)
let g:vimide_prjlist = get(g:, 'vimide_prjlist', '~/.vim/vimide_prj.list')
let s:prjlist = []
let s:currenttag = ''

command! -n=? -complete=dir -bar VideGenerateTag :call s:genTag('<args>')
command! -n=? -complete=dir -bar VideSetTag :call s:setTag('<args>')
command! -n=0 -bar VideUpdateTag :call s:updateTag()
command! -n=0 -bar VideListTag :call s:listProjects()
command! -n=1 -bar VideSelectTag :call s:setTagByIdx(<args>)

nmap <C-\>z :VideSetTag 
nmap <C-\>Z :VideGenerateTag 
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>S :cs find s 
nmap <C-\>G :cs find g 
nmap <C-\>C :cs find c 
nmap <C-\>T :cs find t 
nmap <C-\>E :cs find e 
nmap <C-\>F :cs find f 
nmap <C-\>I :cs find i 
nmap <C-\>D :cs find d 

if g:vimide_showmenu > 0
    exe 'menu VimIDE.Generate\ Tags\.\.\.<tab><C-\\>Z		<C-\>Z'
    exe 'menu VimIDE.Set\ Tags\.\.\.<tab><C-\\>Z		<C-\>z'
    exe 'menu VimIDE.-SEP1-		<Nop>'
    exe 'menu VimIDE.Files\ Browser<tab>\\wl		<Leader>wl'
    exe 'menu VimIDE.Symbols\ Browser<tab>\\wr		<Leader>wr'
    exe 'menu VimIDE.Show\ All<tab>\\wa		<Leader>wa'
    exe 'menu VimIDE.Hide\ All<tab>\\wc		<Leader>wc'
    exe 'menu VimIDE.-SEP2-		<Nop>'
    exe 'menu VimIDE.Symbol.Current<tab><C-\\>s		<C-\>s'
    exe 'menu VimIDE.Symbol.Specified\.\.\.<tab><C-\\>S		<C-\>S'
    exe 'menu VimIDE.Definition.Current<tab><C-\\>g		<C-\>g'
    exe 'menu VimIDE.Definition.Specified\.\.\.<tab><C-\\>G		<C-\>G'
    exe 'menu VimIDE.CalledBy.Current<tab><C-\\>d		<C-\>d'
    exe 'menu VimIDE.CalledBy.Specified\.\.\.<tab><C-\\>D		<C-\>D'
    exe 'menu VimIDE.Calling.Current<tab><C-\\>c		<C-\>c'
    exe 'menu VimIDE.Calling.Specified\.\.\.<tab><C-\\>C		<C-\>C'
    exe 'menu VimIDE.Text.Current<tab><C-\\>t		<C-\>t'
    exe 'menu VimIDE.Text.Specified\.\.\.<tab><C-\\>T		<C-\>T'
    exe 'menu VimIDE.Egrep.Current<tab><C-\\>e		<C-\>e'
    exe 'menu VimIDE.Egrep.Specified\.\.\.<tab><C-\\>E		<C-\>E'
    exe 'menu VimIDE.File.Current<tab><C-\\>f		<C-\>f'
    exe 'menu VimIDE.File.Specified\.\.\.<tab><C-\\>F		<C-\>F'
    exe 'menu VimIDE.Including.Current<tab><C-\\>i		<C-\>i'
    exe 'menu VimIDE.Including.Specified\.\.\.<tab><C-\\>I		<C-\>I'
    exe 'menu VimIDE.-SEP3-		<Nop>'
    exe 'menu VimIDE.Result.Open<tab>:cw		:cw<CR>'
    exe 'menu VimIDE.Result.Close<tab>:ccl		:ccl<CR>'
endif

set cscopequickfix=s-,g-,f-,c-,d-,i-,t-,e-
set timeoutlen=4000
set ttimeout
set ttimeoutlen=100

function! s:inputDir(name)
    let l:dir = fnamemodify(a:name, ':p')
    exe ':chdir '. l:dir
    return l:dir
endfunction
function! s:genTag(name)
    let l:dir=s:inputDir(a:name)
    let l:msg = input('Project Name: ', '')
    exe '!ctags -R'
    exe '!cscope -Rbcu'
    ""update project list
    call s:appendPrjList(l:msg, l:dir)
    ""set tags
    call s:setTag(l:dir)
endfunction
function! s:setTag(name)
    if len(s:currenttag) < 1
        let l:dir=s:inputDir(a:name)
        let l:tagfile = globpath(l:dir, 'tags')
        let l:cscopefile = globpath(l:dir, 'cscope.out')
        if len(l:tagfile) < 1
            echo 'Not found: tags in ' . l:dir
            return
        endif
        if len(l:cscopefile) < 1
            echo 'Not found: cscope.out in ' . l:dir
            return
        endif
        let s:currenttag = l:dir
        exe ':set tags+=' . l:tagfile
        exe ':cs add ' . l:cscopefile
    else
        echo s:currenttag . ' is in connection'
    endif
endfunction
function! s:updateTag()
    if len(s:currenttag) < 1
        echo 'No tags are connected.'
    else
        silent! exe 'cs kill -1'
        exe '!ctags -R'
        exe '!cscope -Rbcu'
        let l:cscopefile = globpath(s:currenttag, 'cscope.out')
        exe ':cs add ' . l:cscopefile
    endif
endfunction

function! s:listProjects()
    if len(s:prjlist) < 1
        call s:loadPrjList()
    endif
    let l:i = 0
    let l:outstr = ''
    while l:i < len(s:prjlist)
        let l:outstr = l:outstr . l:i . ":\t" . join(s:prjlist[l:i], "\t") . "\n"
        let l:i = l:i + 1
    endwhile
    echo l:outstr
endfunction
function! s:loadPrjList()
    let l:fullname = fnamemodify(g:vimide_prjlist, ':p')
    if filereadable(l:fullname)
        for l:line in readfile(l:fullname)
            let l:pos = stridx(l:line, "\t")
            if l:pos > 0
                call add(s:prjlist, [strpart(l:line, 0, l:pos), strpart(l:line, l:pos + 1)])
            endif
        endfor
    endif
endfunction
function! s:savePrjList()
    let l:fullname = fnamemodify(g:vimide_prjlist, ':p')
    let l:outlist = []
    for l:item in s:prjlist
        call add(l:outlist, join(l:item, "\t"))
    endfor
    call writefile(l:outlist, l:fullname)
endfunction
function! s:appendPrjList(prjname, prjroot)
    if len(a:prjname) < 1
        let l:prjname = fnamemodify(a:prjroot, ':p:h:t')
    else
        let l:prjname = a:prjname
    endif
    if len(s:prjlist) < 1
        call s:loadPrjList()
    endif
    for l:item in s:prjlist
        if l:item[1] == a:prjroot
            let l:item[0] = l:prjname
            call s:savePrjList()
            return
        endif
    endfor
    call add(s:prjlist, [l:prjname, a:prjroot])
    call s:savePrjList()
endfunction
function! s:setTagByIdx(idx)
    if a:idx < len(s:prjlist)
        call s:setTag(s:prjlist[a:idx][1])
    endif
endfunction
