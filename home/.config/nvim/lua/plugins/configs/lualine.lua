-- Color table for highlights
local colors = {
  bg = '#202328', --
  fg = '#bbc2cf',
  yellow = '#ECBE7B',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#98be65',
  orange = '#FF8800',
  violet = '#a9a1e1',
  magenta = '#c678dd',
  blue = '#51afef',
  red = '#ec5f67'
}

-- Color table for highlights
local colors2 = {
  active = {
    fg = '#a8a897', -- '#bbc2cf',
    bg = '#30302c',
    boundary = '#51afef',
    paste = '#98be65',
    filepath = '#D7D7BC',
    progress = '#4e4e43'
  },
  inactive = {fg = '#666656', bg = '#30302c'},
  filemode = {modified = '#ec5f67', readonly = '#ec5f67'},
  diagnostics = {error = '#ec5f67', warn = '#ECBE7B', info = '#008080', hint = '#006080'},
  git = {added = '#516C31', modified = '#974505', deleted = '#B73944'}
}

-- local components = {
--   treesitter = {
--     function() return "  " end,
--     condition = function()
--       if next(vim.treesitter.highlighter.active) then return true end
--       return false
--     end,
--     color = {fg = "green"}
--   },
--   diagnostics = {"diagnostics", sources = {"nvim_lsp"}, symbols = {error = " ", warn = " ", info = " ", hint = " "}, color_error = colors.red, color_warn = colors.yellow, color_info = colors.cyan}
-- }

local diagnostics = {
  "diagnostics", --
  sources = {"nvim_diagnostic"},
  -- sections = {"error", "warn"},
  symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '},
  diagnostics_color = { --
    error = {fg = colors2.diagnostics.error},
    warn = {fg = colors2.diagnostics.warn},
    info = {fg = colors2.diagnostics.info},
    hint = {fg = colors2.diagnostics.hint}
  },
  colored = true,
  update_in_insert = false,
  always_visible = true
}

local M = {}

M.config = function()
  local has_lualine, lualine = pcall(require, "lualine")
  if not has_lualine then return end

  lualine.setup({
    options = {
      icons_enabled = true,
      theme = 'moonfly',
      -- component_separators = {left = '', right = ''},
      -- section_separators = {left = '', right = ''},
      -- disabled_filetypes = {"alpha", "dashboard", "NvimTree", "Outline", "toggleterm"},
      disabled_filetypes = {"alpha", "NvimTree", "Outline", "toggleterm"},
      always_divide_middle = true
    },
    sections = {
      lualine_a = {{'mode', upper = true}},
      -- lualine_b = {{'branch', icon = ''}},
      lualine_b = {{'branch', icon = '', icon_only = true}},
      lualine_c = {{'filename', file_status = true}},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {diagnostics},
      lualine_z = {'progess'}
    },
    inactive_sections = {
      lualine_a = {}, --
      lualine_b = {},
      lualine_c = {'filename', 'file_status'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    }
  })
end
return M
