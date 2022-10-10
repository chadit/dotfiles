local M = {}

M.config = function()
  local has_plugin, _ = pcall(require, "moonfly")
  if not has_plugin then return end
  _, _ = pcall(vim.cmd [[colorscheme moonfly]])
end

return M
