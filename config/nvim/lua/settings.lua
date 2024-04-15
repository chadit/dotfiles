-- -- Set leader and localleader
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

local opt = vim.opt

-- Hint: use `:h <option>` to figure out the meaning if needed
-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
opt.mouse = "a" -- allow the mouse to be used in Nvim

-- Tab
opt.tabstop = 4       -- number of visual spaces per TAB
opt.softtabstop = 4   -- number of spacesin tab when editing
opt.shiftwidth = 4    -- insert 4 spaces on a tab
opt.expandtab = true  -- convert tabs to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- UI config
opt.number = true          -- show absolute number
opt.relativenumber = false -- add numbers to each line on the left side

-- Split windows
opt.splitbelow = true    -- open new vertical split bottom
opt.splitright = true    -- open new horizontal splits right

opt.numberwidth = 2      -- set number column width to 4 {default 4}
opt.cursorline = true    -- highlight cursor line underneath the cursor horizontally

opt.termguicolors = true -- enabl 24-bit RGB color in the TUI
opt.showmode = false     -- we are experienced, wo don't need the "-- INSERT --" mode hint

-- Searching
opt.incsearch = true       -- search as characters are entered
opt.hlsearch = true        -- do not highlight matches
opt.ignorecase = true      -- ignore case in searches by default
opt.smartcase = true       -- but make it case sensitive if an uppercase is entered
opt.smartindent = true     -- make indenting smarter again

opt.backup = false         -- creates a backup file
opt.cmdheight = 1          -- more space in the neovim command line for displaying messages
opt.conceallevel = 0       -- so that `` is visible in markdown files
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.pumheight = 10         -- pop up menu height
opt.showtabline = 0        -- always show tabs

opt.writebackup = false    -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

opt.confirm = true         -- confirm to save changes before exiting modified buffer

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- Enable break indent
opt.breakindent = true
-- Save undo history
opt.undofile = true -- enable persistent undo


opt.signcolumn = "yes" -- Keep signcolumn on by default
-- Decrease update time
opt.updatetime = 250   -- faster completion (4000ms default)
opt.timeoutlen = 1000  -- time to wait for a mapped sequence to complete (in milliseconds)

opt.title = true
opt.visualbell = true

opt.shortmess = opt.shortmess + { c = true }

opt.background = "dark" -- tell vim what the background color looks like

opt.guicursor = ""      -- status line handles mode so cursor doesn't need to

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

opt.swapfile = false               -- disable swap file
