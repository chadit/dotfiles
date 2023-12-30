-- init.lua

local function get_directory_files(directory)
  local files = {}
  local p = io.popen('find "' .. directory .. '" -type f')
  if p then
    for file in p:lines() do
      if file:match("%.lua$") then -- Filter for Lua files
        table.insert(files, file)
      end
    end
    p:close()
  end
  return files
end

local function convert_path_to_module(path)
  local module_path = path:match(".*/lua/(plugins/.*)") or path:match(".*/(plugins/.*)")
  local module_name = module_path:gsub("%.lua$", ""):gsub("/", ".")
  return module_name
end

local M = {}

function M.load_plugins()
  -- [[ Install `lazy.nvim` plugin manager ]]
  --    https://github.com/folke/lazy.nvim
  --    `:help lazy.nvim.txt` for more info
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)

  local has_lazy, plg = pcall(require, "lazy")
  if not has_lazy then
    print("no lazy")
    return
  end

  local plugins = {
    { "folke/lazy.nvim",      lazy = false, tag = "stable", priority = 1000 }, -- latest stable release

    -- Git related plugins
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-rhubarb' },

    -- Detect tabstop and shiftwidth automatically
    { 'tpope/vim-sleuth' },

    -- Useful plugin to show you pending keybinds.
    { 'folke/which-key.nvim', opts = {} },

    {
      "simrat39/inlay-hints.nvim",
      config = function()
        require("inlay-hints").setup()
      end,
    },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },
  }

  local base_plugin_path = vim.fn.stdpath("config") .. "/lua/plugins"

  -- Load plugin files
  local loaded_plugins = {}
  local test_plugin_files = get_directory_files(base_plugin_path)
  for _, file in ipairs(test_plugin_files) do
    local plugin_file = convert_path_to_module(file)
    if plugin_file ~= "plugins.init" then
      local has_plugin, plugin = pcall(require, plugin_file)
      if has_plugin and type(plugin) == "table" and not plugin["ignore"] then
        loaded_plugins[plugin_file] = plugin
      end
    end
  end

  -- Add plugins to the list
  for _, loaded_plugin in pairs(loaded_plugins) do
    if loaded_plugin and loaded_plugin.new then
      local plg_data = loaded_plugin.new()
      if plg_data then
        vim.list_extend(plugins, plg_data)
      end
    end
  end

  local extra_opts = {
    defaults = { lazy = false, priority = 1000 },
    ui = { wrap = "true" },
    change_detection = { enabled = true },
  }
  plg.setup(plugins, extra_opts)

  -- run settings for plugins
  for _, loaded_plugin in pairs(loaded_plugins) do
    if loaded_plugin and loaded_plugin.setup then
      loaded_plugin.setup()
    end
  end

  -- run keymaps for plugins
  for _, loaded_plugin in pairs(loaded_plugins) do
    if loaded_plugin and loaded_plugin.keymaps then
      loaded_plugin.keymaps()
    end
  end
end

return M
