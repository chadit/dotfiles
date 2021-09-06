local has_settings, settings = pcall(require, "settings")

if has_settings then settings.defaults() end

local has_plugins, plugins = pcall(require, "plugins")

if has_plugins then plugins.load_plugins() end

-- vim.g.mapleader = ","

-- CONFIG_PATH = vim.fn.stdpath("config")
-- DATA_PATH = vim.fn.stdpath("data")
-- CACHE_PATH = vim.fn.stdpath("cache")

-- -- Plugins and config files
-- require('utils')

-- source('utils/general')
-- require('plugins')

-- print("3")

-- require('mappings')
-- require('colorscheme')

-- -- GalaxyLine and Bufferline Config
-- require('galaxyline-conf')
-- require('bufferline-conf')
-- -- require('dashboard-conf')
-- require('which-key-conf')
-- -- source('plug-conf/which-key')

-- -- Nvim-tree config
-- require('nvim-tree-conf')

-- -- Telescope Config
-- require('telescope-conf')

-- -- Todo Config
-- require('todo-comments-conf')
-- require('trouble-conf')

-- -- Treesitter config
-- require("treesitter-conf")

-- -- Lsp Config
-- source('plug-conf/lsp-config')
-- require('lsp')

-- require('compe-conf')

-- require('ccls-lsp')
-- -- require('lua-lsp')
-- require('golang-lsp')
-- require('python-lsp')
-- -- require('rust-lsp')
-- require('tsserver-lsp')
-- require('rust_tools')

-- source('plug-conf/ale-conf') -- Ale Config
-- source('plug-conf/floaterm-conf') -- Floaterm Config
-- source('plug-conf/fzf-conf') -- FZF Config
