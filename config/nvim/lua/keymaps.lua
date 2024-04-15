-- global keymaps

-- Set leader and localleader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Navigate between panes for tmux
vim.keymap.set('n', '<c-k', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l', ':wincmd l<CR>')
