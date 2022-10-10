local M = {}

M.config = function()
  local has_blankline, blankline = pcall(require, "indent_blankline")
  if not has_blankline then return end

  blankline.setup({
    char = "│",
    --  use_treesitter = true,
    show_current_context = true
    --	filetype_exclude = { "dashboard" },
  })
end

return M
