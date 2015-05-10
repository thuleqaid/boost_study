" Usage :
" New document :
" 1. use <Leader>mn to create an empty markdown file in g:editormd_path
" 2. edit markdown file(index.md)
" 3. use <Leader>mw to save document in formal path
" Edit document :
" 1. use <Leader>ml to load document
" 2. edit markdown file(index.md)
" 3. use <Leader>ms to save document in formal path
" Sequence Grammar
"   title : message
"   participant actor
"   note [left of/right of/over] actor : message
"   actor [-/--] [>/>>] actor : message

let g:editormd_path = get(g:, 'editormd_path', '~/editor.md')
let s:loaded_path = ''

if has("autocmd")
    autocmd FileType mkd set expandtab fenc=utf-8
endif

nmap <Leader>mn :EditorMDNew<CR>
nmap <Leader>mw :EditorMDWrite 
nmap <Leader>ml :EditorMDLoad 
nmap <Leader>ms :EditorMDSave<CR>

command! -n=0 -bar EditorMDNew :call s:emptyPath()
command! -n=1 -complete=dir -bar EditorMDWrite :call s:writePath('<args>')
command! -n=1 -complete=dir -bar EditorMDLoad :call s:loadPath('<args>')
command! -n=0 -bar EditorMDSave :call s:savePath()

function! s:loadPath(dirpath)
    let l:fullpath = fnamemodify(a:dirpath, ':p')
    let l:mdfile = globpath(l:fullpath, 'index.md')
    if len(l:mdfile) > 0
        let s:loaded_path = l:fullpath
        call s:syncL(0)
    endif
    call s:openDocument()
endfunction
function! s:savePath()
    call s:syncS(0)
endfunction

function! s:emptyPath()
    let l:srcpath = substitute(fnamemodify(g:editormd_path, ':p'), '\', '/', 'g')
    silent exe '!rm -rf ' . l:srcpath . 'images/'
    call mkdir(l:srcpath . 'images', 'p')
    silent exe '!rm ' . l:srcpath . 'index.md'
    call s:openDocument()
endfunction
function! s:writePath(dirpath)
    let l:fullpath = fnamemodify(a:dirpath, ':p')
    if !isdirectory(l:fullpath)
        call mkdir(l:fullpath, 'p')
    endif
    let s:loaded_path = l:fullpath
    call s:syncS(0)
endfunction

function! s:syncL(partial)
    if len(s:loaded_path) > 0
        let l:dstpath = substitute(fnamemodify(g:editormd_path, ':p'), '\', '/', 'g')
        let l:srcpath = substitute(s:loaded_path, '\', '/', 'g')
        silent exe '!cp ' . l:srcpath . 'index.md ' . l:dstpath
        if a:partial <= 0
            silent exe '!rm -rf ' . l:dstpath . 'images/'
            silent exe '!cp -r ' . l:srcpath . 'images/ ' . l:dstpath
        endif
    endif
endfunction
function! s:syncS(partial)
    if len(s:loaded_path) > 0
        let l:srcpath = substitute(fnamemodify(g:editormd_path, ':p'), '\', '/', 'g')
        let l:dstpath = substitute(s:loaded_path, '\', '/', 'g')
        silent exe '!cp ' . l:srcpath . 'index.md ' . l:dstpath
        if a:partial <= 0
            silent exe '!rm -rf ' . l:dstpath . 'images/'
            silent exe '!cp -r ' . l:srcpath . 'images/ ' . l:dstpath
        endif
    endif
endfunction
function! s:openDocument()
    let l:srcpath = substitute(fnamemodify(g:editormd_path, ':p'), '\', '/', 'g')
    silent exe 'e ' . l:srcpath . 'index.md'
    silent exe 'w'
endfunction

