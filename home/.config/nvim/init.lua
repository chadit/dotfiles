-- nvim-tree recomends this:
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

local has_settings, settings = pcall(require, [[settings]])
if has_settings then settings.defaults() end

local has_plugins, plugins = pcall(require, [[plugins]])
if has_plugins then plugins.load_plugins() end

-- require([[plugins.lspinstall]])



-- DAP
require([[dbg]])
