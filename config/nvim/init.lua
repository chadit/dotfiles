-- Desc: Main entry point for Neovim configuration
require("settings")

local has_plugins, plugins = pcall(require, [[plugins]])
if has_plugins then
    plugins.load_plugins()
end
