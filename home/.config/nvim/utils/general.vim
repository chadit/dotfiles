syntax on
filetype plugin indent on

set exrc
set spell
set nohlsearch
set noerrorbells
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set nu rnu
set nowrap									" Don't wrap
set smartcase
set noswapfile
set nobackup
set hlsearch
set incsearch
set ignorecase
set smartcase
set vb t_vb=
set termguicolors
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast
set noshowmode
set hidden
set shortmess+=c
set formatoptions-=cro
set modifiable
set clipboard+=unnamedplus
set colorcolumn=120
set mouse=a
set inccommand=nosplit
set backspace=indent,eol,start
set fileformats=unix,dos,mac
set ruler
set number
set autoindent								" Copy the indentation from the current line.
set history=1000                			" Store lots of :cmdline history
" set wildmenu 								" Display completion matches on your status line
" set wildmode=full							" Resets to default
set showcmd                     			" Show incomplete cmds at the bottom
set tags=./tags; 							" Set tags directory
set completeopt-=preview


au InsertEnter * silent execute "!echo -en \<esc>[5 q"
au InsertLeave * silent execute "!echo -en \<esc>[2 q"
autocmd BufNew,BufRead *.asm set ft=nasm
