"
" NATIVE CONFIG
"

"mappings
let mapleader = ' '
inoremap jk <Esc>
vnoremap u <Esc>
"scrolls through modals in insert mode
imap <C-j> <C-n>
imap <C-k> <C-p>

"trailing
noremap <C-c> <S-j>

"faster scrolling
noremap <S-j> 3jzz
noremap <S-k> 3kzz

"buffer
nmap <C-n> :bnext<CR>
nmap <C-p> :bprevious<CR>
nmap <C-y> :bdelete<CR>
map <C-t> :tabnew<CR>

"inserts blank line below
noremap <C-[> :set paste<CR>o<Esc>:set nopaste<CR>
noremap gl $
noremap gh 0

"save
"Control-I is the same as Tab in the terminal
nmap <silent> <leader>u :update<CR>
nmap <silent> <C-i> :update<CR>
nmap <silent> <Tab> :update<CR>
"sudo tee hack, write as root
cmap w!! w !sudo tee > /dev/null %
set autowrite
set autowriteall

"save undo / redo across sessions
set undofile
set undodir=~/.vim/undo

"quit
nmap <C-u> :q<CR>
imap <C-u> <Esc>:q<CR>

"splits
function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key,'[jk]'))
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction

noremap <silent> <C-h> :call WinMove('h')<CR>
noremap <silent> <C-j> :call WinMove('j')<CR>
noremap <silent> <C-k> :call WinMove('k')<CR>
noremap <silent> <C-l> :call WinMove('l')<CR>

"terminal
tnoremap jk <C-\><C-n>
tnoremap <C-u> <C-\><C-n>:q<CR>

"signcolumn
set timeoutlen=500
set signcolumn=yes

"true colors
set termguicolors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

"vim update delay in ms
set updatetime=300

"disable mouse
set mouse=

"syntax
syntax enable
set number
"is not useful in screenshare
"set relativenumber
set autoread
set encoding=UTF-8
"set foldmethod=syntax

"uses system clipboard
set clipboard=unnamedplus

"disable pre rendering of some things like ```
set conceallevel=0

"toggle invisible characters
set list
set listchars=tab:→\ ,eol:¬,trail:~,extends:❯,precedes:❮,space:␣
"set listchars=eol:¬,trail:~,extends:❯,precedes:❮
set showbreak=↪

"default for vim sleuth
set expandtab
set tabstop=2
set shiftwidth=2

"split
set splitbelow
set splitright

"in house fuzzy finder
set path+=**
set wildmenu

"searching
set ignorecase
set smartcase

set cursorline
set laststatus=2
set scrolloff=8
set startofline

augroup save_when_leave
  au BufLeave * silent! wall
augroup END

set hidden
set nobackup
set nowritebackup
set noswapfile
set noshowmode
"automatically source .vimrc from project folder
set exrc
set secure

"jump back to and forth
noremap <leader>o <C-o>zz
noremap <leader>i <C-i>zz

"filetypes
au BufRead,BufNewFile *.nix set filetype=nix
au BufRead,BufNewFile *.libsonnet set filetype=jsonnet
