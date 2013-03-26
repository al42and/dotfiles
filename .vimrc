
"""""""""""""""""""""""""""""" BASIC EDITOR BEHAVIOR 

" Longer history
set history=1000

" Allow switching edited buffers without saving
" (from http://items.sjbach.com/319/configuring-vim-right)
set hidden

set title " Set terminal title

" Smart filetype detection
filetype plugin on
filetype indent on
syntax enable "Enable syntax hl

set so=7 " Add "preview zones" while scrolling

" Tabs
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set wildmenu " Turn on <TAB> suggestions
set wildmode=list:longest " Complete till the longest common substring
set wildignore+=*.o,*.obj,.git,*.pyc,.svn

set lz " Lazy redraw

set ruler "Always show current position

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Search
set ignorecase "Ignore case when searching
set smartcase
set hlsearch "Highlight search things
set incsearch "Make search act like search in modern browsers
set showmatch "Show matching bracets when text indicator is over them

" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c
set laststatus=2

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


" Auto-backup files and .swp files don't go to pwd
set backupdir=~/.vim-tmp,~/.tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,/var/tmp,/tmp

"""""""""""""""""""""""""""""" OMNICOMPLETION

" Omnicompletion
filetype plugin on
set ofu=syntaxcomplete#Complete
au BufNewFile,BufRead,BufEnter *.cpp,*.hpp,*.cu,*.cuh,*.h set omnifunc=omni#cpp#complete#Main
set completeopt-=preview

" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/cuda
set tags+=~/.vim/tags/qt4

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

" SuperTab: autocompletion on <TAB>
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
let g:SuperTabDefaultCompletionType = "context"

"""""""""""""""""""""""""""""" ENCODINGS

set encoding=utf8
try
    lang en_US
catch
endtry

set fencs=utf-8,cp1251,koi8-r,ucs-2,cp866
set ffs=unix,dos,mac "Default file types


"""""""""""""""""""""""""""""" KEYMAPS

set nocompatible              " Don't be compatible with vi
let mapleader = ","

imap ,, <ESC>
" Because we all do it sometimes...
command! W :w
" Redo
map U <C-r>
" Ctrl-Backspace = Ctrl-W
imap <C-BS> <C-W>

" Search
map <space> /
map <c-space> ?
map <silent> <leader><CR> :noh<CR>

" Tabs
map <leader>j :tabprev<CR>
map <leader>k :tabnext<CR>
map <leader>h :tabnew<CR>

" Splits navigation
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Etc...
map <leader>m :!make<CR>
map <leader>t :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --langmap=c:+.cu --langmap=c:+.cuh --exclude=".pc" .<CR>
" Paste mode toggle
set pastetoggle=<leader>l
" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>e mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm


"""""""""""""""""""""""""""""" FILE-TYPE-SPECIFIC HANDLERS

" Delete trailing white space, useful for Python
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

" Make files with shebang executable
function ModeChange()
  if getline(1) =~ "^#!"
    if getline(1) =~ "bin/"
      silent !chmod a+x <afile>
    endif
  endif
endfunction
au BufWritePost * call ModeChange()

" Add boilerplate to .py files
function! WriteInitPy()
  let @q = "\#\!/usr/bin/env python\n\#-*- encoding: utf-8 -*-\n\nfrom sys import argv, exit\n\n"
  execute "0put q"
endfunction
autocmd BufNewFile *.py call WriteInitPy()

" Add boilerplate to .sh files
function! WriteInitSh()
  let @q = "\#\!/bin/bash\n\nset -euo pipefail\n\n"
  execute "0put q"
endfunction
autocmd BufNewFile *.sh call WriteInitSh()

" Python highlighting options
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

" CUDA
au BufRead,BufNewFile *.cuh set filetype=c

" Charmm
au BufRead,BufNewFile *.inp set filetype=charmm
au BufRead,BufNewFile *.charmm set filetype=charmm
au! Syntax charmm source $HOME/.vim/syntax/charmm.vim

autocmd! BufWritePost vimrc source ~/.vimrc " Autoapply vimrc on update

