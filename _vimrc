" mkdir .vim
" cd .vim
" mkdir temp
" git clone http://github.com/gmarik/vundle.git bundle/vundle
set nocompatible

set enc=utf-8
set fileencodings=utf-8,cp936,sjis
set fileformat=unix
set number
set iminsert=0
set imsearch=0
" => temporary dir
" backup
set bk
set bdir=~/.vim/temp
" swap
set dir=~/.vim/temp
"set lines=40 columns=110
set guioptions-=T
set list
set listchars=tab:>-,trail:-
set number
" syntax color
syntax enable
syntax on
" hightlight trailing spaces
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
set ignorecase
set magic
set hls
set is

"convert tab to spaces
"set expandtab
set shiftwidth=4
set tabstop=4
set smarttab
set lbr
set tw=500
set ai
set si
set nowrap

if has("autocmd")
    autocmd FileType python,javascript set expandtab
endif
map <F5> "+y
map <F6> "+p

filetype off                  " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

"Surround
Bundle 'surround.vim'

"VisIncr
Bundle 'VisIncr'

"snipMate
Bundle 'snipMate'

"Calendar
Bundle 'calendar.vim'

"Undo-Tree
Bundle 'mbbill/undotree'
if has("persistent_undo")
    set undodir=~/.vim/temp
    set undofile
endif

"Multiple Highlight
Bundle 'Mark--Karkat'
let g:mwAutoSaveMarks = 0

" MiniBufExplorer
Bundle 'minibufexpl.vim'
let g:miniBufExplMapWindowNavVim=1
set hidden

"NERDCommenter
Bundle 'The-NERD-Commenter'

"NERDTree
Bundle 'The-NERD-tree'

"Tagbar TagList's replacement
Bundle 'Tagbar'
"let g:tagbar_left = 1

"JavaScript-syntax
Bundle 'JavaScript-syntax'

"WordPress
Bundle 'VimRepress'

""vim-pad
"Bundle 'vim-pad'
"let g:pad_dir = '~/.vim/note'

"markdown
Bundle 'godlygeek/tabular'
Bundle 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_initial_foldlevel=1

"Detect file encoding
Bundle 'FencView.vim'

"Git
""Bundle 'fugitive.vim'
Bundle 'motemen/git-vim'
"" show branch name in the status line
"set laststatus=2
"set statusline=%{GitBranch()}
Bundle 'airblade/vim-gitgutter'

"Syntax check
Bundle 'Syntastic'
""C
let g:syntastic_c_check_header=1
let g:syntastic_c_auto_refresh_includes=1
let g:syntastic_c_errorformat='%f:%l:%c:%trror: %m'
let g:syntastic_c_compiler='gcc'
""C++
let g:syntastic_cpp_check_header=1
let g:syntastic_cpp_auto_refresh_includes=1
let g:syntastic_cpp_errorformat='%f:%l:%c:%trror: %m'
let g:syntastic_cpp_compiler_options='-std=c++11'
let g:syntastic_cpp_include_dirs= ['usr/local/include' ]
let g:syntastic_cpp_compiler='g++'
""python

"EasyMotion
Bundle 'EasyMotion'

"Status bar
Bundle 'bling/vim-airline'

"multiple cursors
Bundle 'terryma/vim-multiple-cursors'

nmap <Leader>wl :NERDTreeToggle<CR>
nmap <Leader>wr :TagbarToggle<CR>
nmap <Leader>wa :NERDTree<CR>:TagbarOpen<CR>
nmap <Leader>wc :NERDTreeClose<CR>:TagbarClose<CR>

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install (update) bundles
" :BundleSearch(!) foo - search (or refresh cache first) for foo
" :BundleClean(!)      - confirm (or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle commands are not allowed.

"CScope
"nmap <C-\>a :cs add w:\cscope.out w:\<CR>
nmap <C-\>z :STag 
nmap <C-\>Z :GTag 
nmap <C-\>s mZ:cs find s <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>g mZ:cs find g <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>c mZ:cs find c <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>t mZ:cs find t <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>e mZ:cs find e <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>f mZ:cs find f <C-R>=expand("<cfile>")<CR><CR>	
nmap <C-\>i mZ:cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d mZ:cs find d <C-R>=expand("<cword>")<CR><CR>	
nmap <C-\>S mY:cs find s 
nmap <C-\>G mY:cs find g 
nmap <C-\>C mY:cs find c 
nmap <C-\>T mY:cs find t 
nmap <C-\>E mY:cs find e 
nmap <C-\>F mY:cs find f 
nmap <C-\>I mY:cs find i 
nmap <C-\>D mY:cs find d 
set cscopequickfix=s-,g-,f-,c-,d-,i-,t-,e-
set timeoutlen=4000
set ttimeout 
set ttimeoutlen=100

function! s:inputDir(name)
    let dir = a:name ==# '' ? getcwd() : a:name
    "hack to get an absolute path if a relative path is given
    if has("win16") || has("win32") || has("win64")
        let sep = '\'
    else
        let sep = '/'
    endif
    if dir =~ '^\.'
        let dir = getcwd() . sep . dir
    endif
    let dir = resolve(dir)
    if strlen(dir)>strridx(dir,sep)+1
        let dir=dir . sep
    endif
    exec ':chdir '. dir
    return dir
endfunction
function! s:genTag(name)
    let dir=s:inputDir(a:name)
    "exec ':chdir '. dir
    exec '!ctags -R'
    "exec '!cscope -Rbkq'
    exec '!cscope -Rbc'
    ""set tags
    exec ':set tags=' . dir  . 'tags'
    exec ':cs add ' . dir . 'cscope.out'
endfunction
function! s:setTag(name)
    let dir=s:inputDir(a:name)
    "exec ':chdir '. dir
    if filereadable(dir.'tags')
        exec ':set tags=' . dir  . 'tags'
    else
        echo 'Not found: '. dir . 'tags'
    endif
    if filereadable(dir.'cscope.out')
        exec ':cs add ' . dir . 'cscope.out'
    else
        echo 'Not found: '. dir . 'cscope.out'
    endif
endfunction

command! -n=? -complete=dir -bar GTag :call s:genTag('<args>')
command! -n=? -complete=dir -bar STag :call s:setTag('<args>')

exe 'menu VimIDE.Generate\ Tags\.\.\.<tab><C-\>Z		<C-\>Z'
exe 'menu VimIDE.Set\ Tags\.\.\.<tab><C-\>Z		<C-\>z'
exe 'menu VimIDE.-SEP1-		<Nop>'
exe 'menu VimIDE.WindowManager<tab>\\wm		<Leader>wm'
exe 'menu VimIDE.-SEP2-		<Nop>'
exe 'menu VimIDE.Symbol.Current<tab><C-\>s		<C-\>s'
exe 'menu VimIDE.Symbol.Specified\.\.\.<tab><C-\>S		<C-\>S'
exe 'menu VimIDE.Definition.Current<tab><C-\>g		<C-\>g'
exe 'menu VimIDE.Definition.Specified\.\.\.<tab><C-\>G		<C-\>G'
exe 'menu VimIDE.CalledBy.Current<tab><C-\>d		<C-\>d'
exe 'menu VimIDE.CalledBy.Specified\.\.\.<tab><C-\>D		<C-\>D'
exe 'menu VimIDE.Calling.Current<tab><C-\>c		<C-\>c'
exe 'menu VimIDE.Calling.Specified\.\.\.<tab><C-\>C		<C-\>C'
exe 'menu VimIDE.Text.Current<tab><C-\>t		<C-\>t'
exe 'menu VimIDE.Text.Specified\.\.\.<tab><C-\>T		<C-\>T'
exe 'menu VimIDE.Egrep.Current<tab><C-\>e		<C-\>e'
exe 'menu VimIDE.Egrep.Specified\.\.\.<tab><C-\>E		<C-\>E'
exe 'menu VimIDE.File.Current<tab><C-\>f		<C-\>f'
exe 'menu VimIDE.File.Specified\.\.\.<tab><C-\>F		<C-\>F'
exe 'menu VimIDE.Including.Current<tab><C-\>i		<C-\>i'
exe 'menu VimIDE.Including.Specified\.\.\.<tab><C-\>I		<C-\>I'
exe 'menu VimIDE.-SEP3-		<Nop>'
exe 'menu VimIDE.Result.Open<tab>:cw		:cw<CR>'
exe 'menu VimIDE.Result.Close<tab>:ccl		:ccl<CR>'

