local has_settings, settings = pcall(require, [[settings]])
if has_settings then settings.defaults() end

local has_plugins, plugins = pcall(require, [[plugins]])
if has_plugins then plugins.load_plugins() end

-- require([[plugins.lspinstall]])

-- DAP
require([[dbg]])
