local M = {}

function M.dap_config()
  local has_dap_plugin, dap = pcall(require, "dap")
  if not has_dap_plugin then return end

  dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = { vim.fn.stdpath("data") .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
  }
end

return M
