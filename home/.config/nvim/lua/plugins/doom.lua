local M = {}

M.config = function()
  local hasModule = pcall(require, "doom")
  if hasModule then
    local g = vim.g

    g.doom_contrast = true
    g.doom_borders = false
    g.doom_disable_background = false
    g.doom_italic = false

    require('doom').set()
    --   vim.cmd([[colorscheme nord]])
  end
end

return M
