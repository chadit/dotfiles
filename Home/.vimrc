" either copy to $HOME or symlink it via ln -s /path/to/file /path/to/symlink
" ln -s /home/chadit/Dropbox/envSync/.vimrc /home/chadit/.vimrc

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" source ~/.vimrc.before if it exists.
if filereadable(expand("~/.vimrc.before"))
source ~/.vimrc.before
endif

" ================ Vundle package manager ====================

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'				" Let Vundle Manage itself

Plugin 'ctrlpvim/ctrlp.vim'      			" Full path fuzzy file, buffer, mru, tag, ... finder for Vim. Activate with `C-p`
Plugin 'BufOnly.vim'						" Closes all buffers except the one currently in focus
Plugin 'scrooloose/nerdtree'    			" files tree
Plugin 'jistr/vim-nerdtree-tabs'         	" Make NERDTree work better with tabs
Plugin 'itmammoth/run-rspec.vim'			" Rspec runner
Plugin 'ervandew/supertab'					" Supertab is a vim plugin which allows you to use <Tab> for all your insert completion needs
Plugin 'majutsushi/tagbar'      			" tags tree (dependancy needed https://github.com/universal-ctags/ctags/blob/master/docs/autotools.rst)
Plugin 'tpope/vim-bundler'					" Ruby Bundler support
Plugin 'tpope/vim-endwise'					" Ruby end helper
Plugin 'tpope/vim-fugitive'					" Git Wrapper
Plugin 'nathanaelkane/vim-indent-guides'    " Visual Display Indent levels

Plugin 'prettier/vim-prettier'				" Pretty format for javascript, typescript, less, scss, css, json, graphql and markdown
Plugin 'tpope/vim-rails'					" Ruby on Rails tools
Plugin 'thoughtbot/vim-rspec'				" Run Rspec specs 
Plugin 'vim-utils/vim-ruby-fold'			" Ruby and spec file folding
Plugin 'nelstrom/vim-textobj-rubyblock'		" Custom text object for selecting ruby blocks
Plugin 'kana/vim-textobj-user'				" Create text objects
Plugin 'skalnik/vim-vroom'					" Ruby tests runner
Plugin 'Shougo/vimproc.vim'					" Command execution

Plugin 'fatih/vim-go'						" Golang plugin.
Plugin 'junegunn/fzf.vim'					" search tool for vim-go
Plugin 'Valloric/YouCompleteMe'				" Code-completion for Go/C#/TypeScript/JavaScript/Rust/Java
Plugin 'vim-airline/vim-airline'			" Status Line plugin
Plugin 'vim-airline/vim-airline-themes'     " Themes for status

" ========= GIT ==============
Plugin 'airblade/vim-gitgutter'				" Git diff in gutter
Plugin 'tpope/vim-git'						" Vim Git runtime

" ========= TMUX ==============
Plugin 'christoomey/vim-tmux-navigator'		"Integrate with tmux

" ========= Javascript ==============
Plugin 'mxw/vim-jsx'						" React JSX syntax
Plugin 'pangloss/vim-javascript'			" JavaScript bundle for vim, this bundle provides syntax highlighting and improved indentation.

" ========= DotNet Core =======
Plugin 'OmniSharp/omnisharp-vim'			" omnisharp plugin for dotnet core
Plugin 'vim-syntastic/syntastic'			" Syntax checker
Plugin 'tpope/vim-dispatch'					" Asynchronous build and test dispatcher (used to start Omnisharp server)

" ========= Theme =============
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plugin 'NLKNguyen/papercolor-theme'			" Theme dark colorscheme PaperColor


call vundle#end()            				" required
" ====================================================

" ================ General Config ====================
filetype off                    			" Reset filetype detection first ...
set ttyfast                     			" Indicate fast terminal conn for faster redraw
set ttymouse=xterm2             			" Indicate terminal type for mouse codes
set ttyscroll=3                 			" Speedup scrolling
set laststatus=2							" Show status line always
set autoread                    			" Automatically read changed files
set encoding=utf-8							" Set default encoding to UTF-8
set backspace=indent,eol,start  			" Allow backspace in insert mode
set noerrorbells                			" No beeps
set wildmenu 								" Display completion matches on your status line
set ruler 									" Show the line and column number of the cursor position
set number                      			" Line numbers
set showcmd                     			" Show incomplete cmds down the bottom
set splitright                  			" Vertical windows should be split to right
set splitbelow                  			" Horizontal windows should split to bottom
set autowrite 								" Automatically save before :next, :make etc.
set hidden                      			" Buffer should still exist if window is closed
set fileformats=unix,dos,mac    			" Prefer Unix over Windows over OS 9 formats
set noswapfile								" Don't use swapfile
set nobackup								" Don't create annoying backup files
set nowb
set noshowmatch                 			" Do not show matching brackets by flickering
set noshowmode                  			" We show the mode with airline or lightline
set completeopt=menu,menuone    			" Show popup menu, even if there is one entry
set pumheight=10                			" Completion window max size
set nocursorcolumn              			" Do not highlight column (speeds up highlighting)
set nocursorline                			" Do not highlight cursor (speeds up highlighting)
set lazyredraw                  			" Wait to redraw

set incsearch       						" Find the next match as we type the search
set hlsearch        						" Highlight searches by default
set ignorecase      						" Ignore case when searching...
set smartcase       						" ...unless we type a capital


set lbr 									" Don't line wrap mid-word.
set nowrap									" Don't wrap
set history=1000                			" Store lots of :cmdline history
set timeout timeoutlen=1500

" ================ Theme ======================
syntax enable
syntax on

" ======= Paper Color ========
set background=dark
colorscheme PaperColor
" ============================

"set background=dark
"set guifont=Source\Code\Pro:h30

" colorscheme Tomorrow-Night-Bright
" colorscheme codedark           				" Visual Studio Dark Theme
" colorscheme molokai     
" colorscheme material-theme

let g:airline_theme='papercolor'
"let g:airline_theme = 'codedark'
"let g:airline_theme = 'molokai'
"let g:airline_theme = 'simple'

" ================ Airline settings ======================

let g:airline#extensions#tabline#buffer_nr_show = 1 " Shows the number next to the buffer, can use :b #
let g:airline#extensions#tabline#enabled = 1 		" Enable the list of buffers accross the top
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t' 	" Show just the filename



" Enable to copy to clipboard for operations like yank, delete, change and put
" http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
if has('unnamedplus')
 set clipboard^=unnamed
  set clipboard^=unnamedplus
endif

" Persistent undo ---------------------- {{{
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && !isdirectory(expand('~').'/.vim/backups')
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile
endif
" }}}

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
let mapleader=","

" Quickly save your file.
map <leader>w :w!<cr>

" Jump to next error with Ctrl-n and previous error with Ctrl-m. Close the
" quickfix window with <leader>a
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" Visual linewise up and down by default (and use gj gk to go quicker)
noremap <Up> gk
noremap <Down> gj
noremap j gj
noremap k gk


" Vim folding settings ---------------------- {{{
set foldmethod=manual

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf
" }}}


" ================ Scrolling ========================
set scrolloff=3         "Start scrolling when we're 8 lines away from margins
"set sidescrolloff=15
"set sidescroll=1

" ================ Indentation ======================

set autoindent				" Copy the indentation from the current line.
set smartindent 			" Enable smart autoindenting.
set shiftwidth=4
set softtabstop=4
set tabstop=4				" Make a tab equal to 4 spaces
set expandtab 				" Use spaces instead of tabs
set smarttab 				" Enable smart tabs

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

set linebreak    "Wrap lines at convenient points

" ================ Custom Settings ========================

" Window pane resizing
nnoremap <silent> <Leader>[ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>] :exe "resize " . (winheight(0) * 2/3)<CR>

" ===== Seeing Is Believing =====
" " Assumes you have a Ruby with SiB available in the PATH
" " If it doesn't work, you may need to `gem install seeing_is_believing -v
" 3.0.0.beta.6`
" " ...yeah, current release is a beta, which won't auto-install
"
" " Annotate every line
"
nmap <leader>b :%!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk<CR>;
"
"  " Annotate marked lines
"
nmap <leader>n :%.!seeing_is_believing --timeout 12 --line-length 500 --number-of-captures 300 --alignment-strategy chunk --xmpfilter-style<CR>;
"
"  " Remove annotations
"
nmap <leader>c :%.!seeing_is_believing --clean<CR>;
"
"  " Mark the current line for annotation
"
nnoremap <leader>m A # => <Esc>
"
"  " Mark the highlighted lines for annotation
"
vnoremap <leader>m :norm A # => <Esc>

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

noremap <Leader>y "+y
noremap <Leader>d "+d

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> {Left-mapping} :TmuxNavigateLeft<cr>
nnoremap <silent> {Down-Mapping} :TmuxNavigateDown<cr>
nnoremap <silent> {Up-Mapping} :TmuxNavigateUp<cr>
nnoremap <silent> {Right-Mapping} :TmuxNavigateRight<cr>
nnoremap <silent> {Previous-Mapping} :TmuxNavigatePrevious<cr>

let g:spec_runner_dispatcher = "VtrSendCommand! {command}"

" RSpec.vim mappings
noremap <Leader>t :call RunCurrentSpecFile()<CR>
noremap <Leader>s :call RunNearestSpec()<CR>
noremap <Leader>l :call RunLastSpec()<CR>
noremap <Leader>a :call RunAllSpecs()<CR>

nnoremap <leader>irb :VtrOpenRunner {'orientation': 'h', 'percentage': 50, 'cmd': 'irb'}<cr>

" For ruby block selections
runtime macros/matchit.vim

" For Running plain Ruby test scripts
nnoremap <leader>r :RunSpec<CR>
nnoremap <leader>l :RunSpecLine<CR>
nnoremap <leader>e :RunSpecLastRun<CR>
nnoremap <leader>cr :RunSpecCloseResult<CR>

" Move line down and up
noremap <Leader>- :m .+1<CR>
noremap <Leader>= :m .-2<CR>

" Uppercase converter for insert and normal mode
vnoremap <c-u> U

" Open up vimrc in new pane
nnoremap <leader>ev :vsplit $MYVIMRC<cr>

" Source new changes
nnoremap <leader>sv :source $MYVIMRC<cr>

" Show hidden files in NERDtree
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen = 0
nnoremap <Leader>d :let NERDTreeQuitOnOpen = 1<bar>NERDTreeToggle<CR>
nnoremap <Leader>D :let NERDTreeQuitOnOpen = 0<bar>NERDTreeToggle<CR>

" =============== Toggles the nerd tree on and off =====================
map <C-n> :NERDTreeToggle<CR>

" For mouse click in NERDTree
:set mouse=a
let g:NERDTreeMouseMode=3

" Abbreviations
iabbrev init initialize
iabbrev dep dependent: :destroy
iabbrev ewo each_with_object
iabbrev des describe
iabbrev vpo validates_presence_of :

" Adding quotes
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel

" Override for beginning and end of line nav
nnoremap H 0
nnoremap L $

" Autocommands

augroup filetype_autocompletes
    autocmd!
    autocmd FileType python :iabbrev <buffer> iff if:<left>
    autocmd FileType javascript :iabbrev <buffer> iff if ()<left>
augroup END

" Operator pending mappings

"" Run cin( to delete and start typing in the next parens on that line
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap in{ :<c-u>normal! f{vi{<cr>

" =============== Config for Plugin ctrlpvim/ctrlp.vim / For ctags <> ctrlptag integration =====================
nnoremap <leader>. :CtrlPTag<cr>

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Prettier install and config
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync


" close vim if the only window left open is a NERDTree
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Refresh NERDTree when focus is moved to it
autocmd BufWritePost * NERDTreeFocus | execute 'normal R' | wincmd p

" ================ fatih/vim-go =========================================
let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1				"Highlight struct and interface names
let g:go_highlight_fields = 1				"Highlight struct field names
let g:go_highlight_functions = 1			"Highlight function and method declarations.
let g:go_highlight_function_arguments = 1	"Highlight the variable names in arguments and return values in function
let g:go_highlight_function_calls = 1		"Highlight function and method calls.
let g:go_highlight_extra_types = 1			"Highlight commonly used library types (`io.Reader`, etc.). >
let g:go_highlight_generate_tags = 1		
let g:go_highlight_operators = 1  			"Highlight operators such as `:=` , `==`, `-=`, etc.
let g:go_highlight_build_constraints = 1 	"Highlights build constraints

" ================ nathanaelkane/vim-indent-guides ======================
let g:indent_guides_enable_on_vim_startup = 1   " Enable indent guides
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=235
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=16

" ================== majutsushi/tagbar ==================================
nmap <F8> :TagbarToggle<CR>

" ================== Fix indentation ==================================
nmap <F7> mzgg=G`z

" ================== Copy ==================================
vmap <C-c> "+y

" ================== vim-gitgutter ==================================
let g:gitgutter_max_signs=9999				" sets gitgutter to max

" ======================= Markdown Preview Chrome =======================
" Open markdown files with Chrome. (https://chrome.google.com/webstore/detail/markdown-preview-plus/febilkbfcbhebfnokafefeacimjdckgl)
autocmd BufEnter *.md exe 'noremap <F5> :!/usr/bin/google-chrome-stable %:p<CR>'