"""""""""""""""""""""""""""""" BASIC EDITOR BEHAVIOR 

" Longer history
set history=1000

" Allow switching edited buffers without saving
" (from http://items.sjbach.com/319/configuring-vim-right)
set hidden

set title " Set terminal title

" Smart filetype detection
"
syntax on
filetype on
filetype plugin on
filetype indent on

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
" ,+<Enter> to hide sighlighted search terms
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

" Paste mode toggle
set pastetoggle=<leader>l
" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>e mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Highlight special characters
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

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
  let @q = "\#\!/usr/bin/env python3\n\n"
  execute "0put q"
endfunction
autocmd BufNewFile *.py call WriteInitPy()

" Add boilerplate to .sh files
function! WriteInitSh()
  let @q = "\#\!/bin/bash\n\nset -euo pipefail\n\n"
  execute "0put q"
endfunction
autocmd BufNewFile *.sh call WriteInitSh()

autocmd! BufWritePost vimrc source ~/.vimrc " Autoapply vimrc on update

