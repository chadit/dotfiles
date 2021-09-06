" ================ My Custom Plugins ====================

Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plug 'NLKNguyen/papercolor-theme'					" Theme dark colorscheme PaperColor
Plug 'OmniSharp/omnisharp-vim'						" omnisharp plugin for dotnet core
Plug 'christoomey/vim-tmux-navigator'				" Integrate with tmux
Plug 'nathanaelkane/vim-indent-guides'    			" Visual Display Indent levels

" A File Explorer For Neovim Written In Lua
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'ryanoasis/vim-devicons'

" highly extendable fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" galaxyline is a light-weight and Super Fast statusline plugin.
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}

"Plug 'w0rp/ale'										" Asynchronous linting/fixing for Vim and Language Server Protocol (LSP) integration
Plug 'RRethy/vim-illuminate'						" selectively illuminating other uses of current word under the cursor
Plug 'vim-ruby/vim-ruby'							" Vim Ruby
Plug 'janko-m/vim-test'								" For tests
Plug 'tpope/vim-dispatch'							" Dispatching the test runner to tmux pane
Plug 'mileszs/ack.vim'								" ACK support inside VIM
Plug 'luochen1990/rainbow'							" Rainbow Parentheses
Plug 'ycm-core/YouCompleteMe'						" Autocomplete

"Plug 'preservim/nerdtree'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
"Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'andrejlevkovitch/vim-lua-format'				" Lua Formatter
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" need pynvim (pip3 install pynvim)

Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'racer-rust/vim-racer'
Plug 'vim-syntastic/syntastic'

" debugger
Plug 'puremourning/vimspector'

" async
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

" tabnine - code completion
Plug 'codota/tabnine-vim'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_lua_checkers = ["luac", "luacheck"]
let g:syntastic_lua_luacheck_args = "--no-unused-args" 







