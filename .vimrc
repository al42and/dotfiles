set history=700

filetype plugin on
filetype indent on

autocmd! bufwritepost vimrc source ~/.vim_runtime/vimrc

set so=7

set tabstop=4
set shiftwidth=4
set smarttab
set et

set lz " Lazy redraw

"set listchars=tab:··
"set list

set wildmenu "Turn on WiLd menu

set ruler "Always show current position

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase "Ignore case when searching
set smartcase
set hlsearch "Highlight search things
set incsearch "Make search act like search in modern browsers
set showmatch "Show matching bracets when text indicator is over them

syntax enable "Enable syntax hl

" Omnicompletion
filetype plugin on
set ofu=syntaxcomplete#Complete
au BufNewFile,BufRead,BufEnter *.cpp,*.hpp,*.cu,*.cuh,*.h set omnifunc=omni#cpp#complete#Main

" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/cuda
set tags+=~/.vim/tags/qt4
" " build tags of your own project with Ctrl-F12
"
" " OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set nocp

let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabDefaultCompletionType = "context"

set encoding=utf8
try
    lang en_US
catch
endtry

set fencs=utf-8,cp1251,koi8-r,ucs-2,cp866
set ffs=unix,dos,mac "Default file types


""""""""""""""""""""""""""""""
" => Visual mode related
"""""""""""""""""""""""""""""""
" Really useful!
" In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

map <space> /
map <c-space> ?
map <silent> <leader><cr> :noh<cr>


" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c


function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction

" My useful comma-stuff
imap ,, <ESC>
set pastetoggle=,l
map ,m :!make<CR>
map ,t :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --langmap=c:+.cu --langmap=c:+.cuh --exclude=".pc" .<CR>
map ,j :tabp<CR>
map ,k :tabn<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

function ModeChange()
  if getline(1) =~ "^#!"
    if getline(1) =~ "bin/"
      silent !chmod a+x <afile>
    endif
  endif
endfunction
au BufWritePost * call ModeChange()


set guitablabel=%t


""""""""""""""""""""""""""""""
" => Python section
"""""""""""""""""""""""""""""""

let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au FileType python inoremap <buffer> $r return
au FileType python inoremap <buffer> $i import
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def


""""""""""""""""""""""""""""""
" => Command-T
"""""""""""""""""""""""""""""""
let g:CommandTMaxHeight = 15
set wildignore+=*.o,*.obj,.git,*.pyc,.svn
noremap <leader>j :CommandT<cr>
noremap <leader>y :CommandTFlush<cr>



" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
" CUDA
au BufRead,BufNewFile *.cuh set filetype=cu

" Charmm
au BufRead,BufNewFile *.inp set filetype=charmm
au BufRead,BufNewFile *.charmm set filetype=charmm
au! Syntax charmm source $HOME/.vim/syntax/charmm.vim


