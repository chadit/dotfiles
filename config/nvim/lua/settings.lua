-- Set leader and localleader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Hint: use `:h <option>` to figure out the meaning if needed
vim.opt.clipboard = 'unnamedplus' -- use system clipboard
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }
vim.opt.mouse = 'a' -- allow the mouse to be used in Nvim

-- Tab
vim.opt.tabstop = 4      -- number of visual spaces per TAB
vim.opt.softtabstop = 4  -- number of spacesin tab when editing
vim.opt.shiftwidth = 4   -- insert 4 spaces on a tab
vim.opt.expandtab = true -- convert tabs to spaces

-- UI config
vim.opt.number = true         -- show absolute number
vim.opt.relativenumber = true -- add numbers to each line on the left side
vim.opt.numberwidth = 2       -- set number column width to 4 {default 4}
vim.opt.cursorline = true     -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true     -- open new vertical split bottom
vim.opt.splitright = true     -- open new horizontal splits right
vim.opt.termguicolors = true  -- enabl 24-bit RGB color in the TUI
vim.opt.showmode = false      -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
vim.opt.incsearch = true       -- search as characters are entered
vim.opt.hlsearch = false       -- do not highlight matches
vim.opt.ignorecase = true      -- ignore case in searches by default
vim.opt.smartcase = true       -- but make it case sensitive if an uppercase is entered
vim.opt.smartindent = true     -- make indenting smarter again

vim.opt.backup = false         -- creates a backup file
vim.opt.cmdheight = 1          -- more space in the neovim command line for displaying messages
vim.opt.conceallevel = 0       -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.pumheight = 10         -- pop up menu height
vim.opt.showtabline = 0        -- always show tabs

vim.opt.writebackup = false    -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

vim.opt.confirm = true         -- confirm to save changes before exiting modified buffer

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")


-- Enable break indent
vim.opt.breakindent = true
-- Save undo history
vim.opt.undofile = true -- enable persistent undo

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'
-- Decrease update time
vim.opt.updatetime = 250  -- faster completion (4000ms default)
vim.opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)

vim.opt.title = true
vim.opt.visualbell = true

vim.opt.shortmess = vim.opt.shortmess + { c = true }
