-- lualine.lua

local M = {}

function M.new()
  return {
    {
      -- Set lualine as statusline
      'nvim-lualine/lualine.nvim',
      dependencies = {
        "catppuccin/nvim", -- not a real dependency, but needed for theme
      },
      config = function()
        -- See `:help lualine.txt`
        require('lualine').setup({
          options = {
            icons_enabled = true,
            theme = 'catppuccin-mocha',
            component_separators = '|',
            section_separators = '',
          },
        })
      end,
    }
  }
end

return M
