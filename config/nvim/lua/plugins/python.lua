-- python.lua

local show = vim.schedule_wrap(function(msg)
  local has_notify, notify = pcall(require, "plugins.notify")
  if has_notify then
    notify.notify_info(msg, "python")
  end
end)

local M = {}


function M.config()
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
      show("Formatting python file")
      vim.lsp.buf.format({ async = true }) -- format only
    end,
  })
end

function M.dap_config()
  local has_dap_plugin, dap = pcall(require, "dap")
  if not has_dap_plugin then
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          local path = require('mason-registry').get_package('debugpy'):get_install_path()
          return path .. '/venv/bin/python'
        end,
      },
    }
  end
end

return M
