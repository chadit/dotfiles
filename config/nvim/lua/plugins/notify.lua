-- notify.lua

local M = {}

function M.new()
  return {
    {
      'rcarriga/nvim-notify',
      config = function()
        local has_plugin, plg = pcall(require, "notify")
        if not has_plugin then return end
        vim.notify = plg
      end,
    },
  }
end

function M.notify_error(message, title)
  local has_plugin, plg = pcall(require, "notify")
  if not has_plugin then return end
  plg(message, "error", { title = title })
end

function M.notify_info(message, title)
  local has_plugin, plg = pcall(require, "notify")
  if not has_plugin then return end
  plg(message, "info", { title = title })
end

return M
