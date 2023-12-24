-- theme.lua

local M = {}

function M.new()
  return {
    { -- catppuccin/nvim
      "catppuccin/nvim",
      lazy = false,
      name = "catppuccin",
      priority = 1000,
      config = function()
        -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha

        -- setup must be called before loading
        vim.cmd.colorscheme 'catppuccin-mocha'
      end,
    },
  }
end

return M
