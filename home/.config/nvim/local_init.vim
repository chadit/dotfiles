" ======= Paper Color ========
set background=dark   						" Type of background being used, Vim will attempt to use colors that look good with that type of background during syntax highlighting
colorscheme PaperColor
" ============================

set autoindent								" Copy the indentation from the current line.
set nowrap									" Don't wrap
set history=1000                			" Store lots of :cmdline history
set wildmenu 								" Display completion matches on your status line
set wildmode=full							" Resets to default
set showcmd                     			" Show incomplete cmds at the bottom
set tags=./tags; 							" Set tags directory
set completeopt-=preview
set mouse=a

" Sets title bar to file name
autocmd BufEnter * let &titlestring = hostname() . "[" . expand("%:t") . "]"

" Show trailing whitespace and spaces before a tab:
:highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\\t/

augroup myfiletypes
	" Clear old autocmds in group
	autocmd!
	" autoindent with two spaces, always expand tabs
	autocmd FileType eruby,yaml,markdown set ai sw=2 sts=2 et
augroup END

if has('nvim')
  let test#strategy = "neovim"
else
  let test#strategy = "dispatch"
endif

" Galaxyline config
luafile $HOME/Projects/src/github.com/chadit/dotfiles/home/.config/nvim

"*****************************************************************************
"" vim-airline/vim-airline
"*****************************************************************************
"let g:airline_theme = 'papercolor'
"let g:airline#extensions#tabline#buffer_nr_show = 1 " Shows the number next to the buffer, can use :b #
"let g:airline#extensions#tabline#fnamemod = ':t' 	" Show just the filename


"*****************************************************************************
"" airblade/vim-gitgutter
"*****************************************************************************
let g:gitgutter_max_signs=1000				" sets gitgutter to max (9999)
let g:gitgutter_eager = 0

"*****************************************************************************
"" Nerd Tree
"*****************************************************************************
"" For mouse click in NERDTree
set mouse=a
"let g:NERDTreeMouseMode=3

"" Show hidden files in NERDtree
"let NERDTreeShowHidden=1
"let NERDTreeQuitOnOpen = 0
"nnoremap <Leader>d :let NERDTreeQuitOnOpen = 1<bar>NERDTreeToggle<CR>
"nnoremap <Leader>D :let NERDTreeQuitOnOpen = 0<bar>NERDTreeToggle<CR>

"" open a NERDTree automatically when vim starts up if no files were specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"map <C-n> :NERDTreeToggle<CR>

"let g:NERDTreeShowBookmarks=0
"let g:NERDTreeMapOpenInTabSilent = 'T'
"let g:NERDTreeWinSize = 25

" NERDTree
"let g:NERDTreeShowHidden = 1 
"let g:NERDTreeMinimalUI = 1 " hide helper
"let g:NERDTreeIgnore = ['^node_modules$'] " ignore node_modules to increase load speed 
"let g:NERDTreeStatusline = '' " set to empty to use lightline
" " Toggle
"noremap <silent> <C-n> :NERDTreeToggle<CR>
" " Close window if NERDTree is the last one
"autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" " Map to open current file in NERDTree and set size
"nnoremap <leader>pv :NERDTreeFind<bar> :vertical resize 45<CR>

" NERDTree Syntax Highlight
" " Enables folder icon highlighting using exact match
"let g:NERDTreeHighlightFolders = 1 
" " Highlights the folder name
"let g:NERDTreeHighlightFoldersFullName = 1 
" " Color customization
let s:brown = "905532"
let s:aqua =  "3AFFDB"
let s:blue = "689FB6"
let s:darkBlue = "44788E"
let s:purple = "834F79"
let s:lightPurple = "834F79"
let s:red = "AE403F"
let s:beige = "F5C06F"
let s:yellow = "F09F17"
let s:orange = "D4843E"
let s:darkOrange = "F16529"
let s:pink = "CB6F6F"
let s:salmon = "EE6E73"
let s:green = "8FAA54"
let s:lightGreen = "31B53E"
let s:white = "FFFFFF"
let s:rspec_red = 'FE405F'
let s:git_orange = 'F54D27'
" " This line is needed to avoid error
"let g:NERDTreeExtensionHighlightColor = {} 
" " Sets the color of css files to blue
"let g:NERDTreeExtensionHighlightColor['css'] = s:blue 
" " This line is needed to avoid error
"let g:NERDTreeExactMatchHighlightColor = {} 
" " Sets the color for .gitignore files
"let g:NERDTreeExactMatchHighlightColor['.gitignore'] = s:git_orange 
" " This line is needed to avoid error
"let g:NERDTreePatternMatchHighlightColor = {} 
" " Sets the color for files ending with _spec.rb
"let g:NERDTreePatternMatchHighlightColor['.*_spec\.rb$'] = s:rspec_red 
" " Sets the color for folders that did not match any rule
let g:WebDevIconsDefaultFolderSymbolColor = s:beige 
" " Sets the color for files that did not match any rule
let g:WebDevIconsDefaultFileSymbolColor = s:blue 

" NERDTree Git Plugin
"let g:NERDTreeGitStatusIndicatorMapCustom = {
""                \ 'Modified'  :'✹',
""                \ 'Staged'    :'✚',
""                \ 'Untracked' :'✭',
""                \ 'Renamed'   :'➜',
""                \ 'Unmerged'  :'═',
""                \ 'Deleted'   :'✖',
""                \ 'Dirty'     :'✗',
""                \ 'Ignored'   :'☒',
""                \ 'Clean'     :'✔︎',
""                \ 'Unknown'   :'?',
""                \ }

"augroup nerdtree_open
""    autocmd!
""    autocmd VimEnter * NERDTree | wincmd p
"augroup END

"*****************************************************************************
"" nathanaelkane/vim-indent-guides
"*****************************************************************************
let g:indent_guides_enable_on_vim_startup = 1   " Enable indent guides
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=235
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=16

"*****************************************************************************
"" w0rp/ale
"*****************************************************************************
" let g:ale_linters = { 'cs': ['OmniSharp'], 'eruby': ['erubylint'] }

"*****************************************************************************
"" OmniSharp/omnisharp-vim
"*****************************************************************************
let g:OmniSharp_server_path = '/opt/omnisharp-roslyn/OmniSharp.exe'
let g:OmniSharp_server_type = 'roslyn'
let g:OmniSharp_server_use_mono = 1
let g:OmniSharp_prefer_global_sln = 1  
let g:OmniSharp_timeout = 10

let g:OmniSharp_selector_ui = 'unite'  " Use unite.vim
let g:OmniSharp_selector_ui = 'ctrlp'  " Use ctrlp.vim
let g:OmniSharp_selector_ui = 'fzf'    " Use fzf.vim
let g:OmniSharp_selector_ui = ''       " Use vim - command line, quickfix etc.

" ======================= Markdown Preview Chrome ============================
" Open markdown files with Chrome. (https://chrome.google.com/webstore/detail/markdown-preview-plus/febilkbfcbhebfnokafefeacimjdckgl)
autocmd BufEnter *.md exe 'noremap <F5> :!/usr/bin/google-chrome-stable %:p<CR>'

" ======================= majutsushi/tagbar ==================================
nmap <F8> :TagbarToggle<CR>

"*****************************************************************************
"" plasticboy/vim-markdown
"*****************************************************************************
" let g:vim_markdown_folding_disabled = 1

"*****************************************************************************
"" Shougo/deoplete.nvim
"*****************************************************************************
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_completion_start_length = 1

"*****************************************************************************
"" racer-rust/vim-racer
"*****************************************************************************
au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)


autocmd FileType lua nnoremap <buffer> <c-k> :call LuaFormat()<cr>
autocmd BufWrite *.lua call LuaFormat()

"*****************************************************************************
"" junegunn/fzf
"*****************************************************************************
nnoremap <C-p> :GFiles<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}


" needs silversearcher-ag installed
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

"*****************************************************************************
" kyazdani42/nvim-tree.lua
"*****************************************************************************
let g:nvim_tree_side = 'right' "left by default
let g:nvim_tree_width = 40 "30 by default, can be width_in_columns or 'width_in_percent%'
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
let g:nvim_tree_gitignore = 1 "0 by default
let g:nvim_tree_auto_open = 1 "0 by default, opens the tree when typing `vim $DIR` or `vim`
let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
let g:nvim_tree_auto_ignore_ft = [ 'startify', 'dashboard' ] "empty by default, don't auto open tree on specific filetypes.
let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
let g:nvim_tree_follow = 1 "0 by default, this option allows the cursor to be updated when entering a buffer
let g:nvim_tree_follow_update_path = 1 "0 by default, will update the path of the current dir if the file is not inside the tree. Default is 0
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_hide_dotfiles = 1 "0 by default, this option hides files and folders starting with a dot `.`
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_tab_open = 1 "0 by default, will open the tree when entering a new tab and the tree was previously open
let g:nvim_tree_auto_resize = 0 "1 by default, will resize the tree to its saved width when opening a file
let g:nvim_tree_disable_netrw = 0 "1 by default, disables netrw
let g:nvim_tree_hijack_netrw = 0 "1 by default, prevents netrw from automatically opening when opening directories (but lets you keep its other utilities)
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_lsp_diagnostics = 1 "0 by default, will show lsp diagnostics in the signcolumn. See :help nvim_tree_lsp_diagnostics
let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
let g:nvim_tree_hijack_cursor = 0 "1 by default, when moving cursor in the tree, will position the cursor at the start of the file on the current line
let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
let g:nvim_tree_update_cwd = 1 "0 by default, will update the tree cwd when changing nvim's directory (DirChanged event). Behaves strangely with autochdir set.
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_refresh_wait = 500 "1000 by default, control how often the tree can be refreshed, 1000 means the tree can be refresh once per 1000ms.
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'packer',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }
" Dictionary of buffer option names mapped to a list of option values that
" indicates to the window picker that the buffer's window should not be
" selectable.
let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 0,
    \ 'files': 0,
    \ 'folder_arrows': 0,
    \ }
"If 0, do not show the icons for one of 'git' 'folder' and 'files'
"1 by default, notice that if 'files' is 1, it will only display
"if nvim-web-devicons is installed and on your runtimepath.
"if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
"but this will not work when you set indent_markers (because of UI conflict)

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   },
    \   'lsp': {
    \     'hint': "",
    \     'info': "",
    \     'warning': "",
    \     'error': "",
    \   }
    \ }

nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
" NvimTreeOpen, NvimTreeClose and NvimTreeFocus are also available if you need them

set termguicolors " this variable must be enabled for colors to be applied properly

" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeFolderIcon guibg=blue


"*****************************************************************************
" nvim-telescope/telescope.nvim
"*****************************************************************************
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>