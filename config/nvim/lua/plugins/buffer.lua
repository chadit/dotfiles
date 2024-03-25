-- buffer.lua

local M = {}

function M.new()
  return {
    {
      'romgrk/barbar.nvim',
      dependencies = {
        'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      },
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {
        clickable = true,
        sidebar_filetypes = { -- sets offset to start after neotree
          ["neo-tree"] = { event = "BufWipeout", text = "Neotree" },
        },
        icons = {
          buffer_index = false,
          buffer_number = false,
          button = '',
          diagnostics = {
            [vim.diagnostic.severity.ERROR] = { enabled = true, icon = '✖ ' },
            [vim.diagnostic.severity.WARN] = { enabled = true, icon = '⚠ ' },
            [vim.diagnostic.severity.INFO] = { enabled = false },
            [vim.diagnostic.severity.HINT] = { enabled = true },
          },
          gitsigns = {
            added = { enabled = true, icon = '+' },
            changed = { enabled = true, icon = '~' },
            deleted = { enabled = true, icon = '-' },
          },
          separator = { left = '▎', right = '' },
          modified = { button = '●' },
          pinned = { button = '', filename = true },
        },
      },
    }
  }
  -- return {
  --   {
  --     "akinsho/bufferline.nvim",
  --     version = "*",
  --     dependencies = "nvim-web-devicons",
  --     config = function()
  --       local has_plugin, plg = pcall(require, "bufferline")
  --       if not has_plugin then
  --         return
  --       end

  --       plg.setup({
  --         options = {
  --           mode = "buffers",
  --           themable = true,
  --           numbers = "buffer_id",
  --           tab_size = 16,
  --           buffer_close_icon = '󰅖',
  --           modified_icon = '●',
  --           close_icon = '',
  --           left_trunc_marker = '',
  --           right_trunc_marker = '',
  --           diagnostics = "nvim_lsp",
  --           ---@diagnostic disable-next-line: unused-local
  --           diagnostics_indicator = function(count, level, diagnostics_dict, context)
  --             local icon = level:match("error") and " " or " "
  --             return " " .. icon .. count
  --           end,
  --           offsets = {
  --             {
  --               filetype = "neo-tree",
  --               text = "File Explorer",
  --               highlight = "Directory",
  --               text_align = "left",
  --             },
  --           },
  --           sort_by = function(buffer_a, buffer_b)
  --             return buffer_a.ordinal < buffer_b.ordinal
  --           end,
  --         },
  --       })
  --     end,
  --   },
  -- }
end

return M
