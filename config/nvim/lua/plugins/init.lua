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

  --plg.setup({

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
      -- Add indentation guides even on blank lines
      'lukas-reineke/indent-blankline.nvim',
      -- Enable `lukas-reineke/indent-blankline.nvim`
      -- See `:help ibl`
      main = 'ibl',
      opts = {},
    },

    {
      "simrat39/inlay-hints.nvim",
      config = function()
        require("inlay-hints").setup()
      end,
    },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },
  }

  -- Load config for plugins
  local loaded_plugins = {}
  local plugin_files = {
    "plugins.git",
    "plugins.lsp",
    "plugins.neo-tree",
    "plugins.notify",
    "plugins.telescope",
    "plugins.treesitter",
    "plugins.theme",
    "plugins.lualine",
    "plugins.autocomplete",
    "plugins.rust",
    "plugins.go",
  }

  for _, plugin_file in ipairs(plugin_files) do
    local has_plugin, plugin = pcall(require, plugin_file)
    if has_plugin then
      loaded_plugins[plugin_file] = plugin
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

  local extra_opts = {}
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
