-- local gitsigns_mappings = require("plugins.gitsigns").keymaps
-- local lsp_mappings = require("settings.lsp.mappings")
local nvimtree_mappings = require("plugins.configs.nvimtree").keymaps
local package_info = require("plugins.package-info").keymaps
local telescope_mappings = require("plugins.telescope").keymaps
-- local trouble_mappings = require("plugins.trouble").keymaps
-- local ts_lsp_mappings = require("plugins.lsp-ts-utils").keymaps

local extend_table = vim.tbl_deep_extend
local has_notify, notify = pcall(require, "notify")

-- local has_mappings, wk_mappings = pcall(extend_table, "error", gitsigns_mappings, lsp_mappings, nvimtree_mappings, package_info, telescope_mappings, trouble_mappings, ts_lsp_mappings)
-- local has_mappings, wk_mappings = pcall(extend_table, "error", gitsigns_mappings, nvimtree_mappings, package_info, telescope_mappings, trouble_mappings, ts_lsp_mappings)
local has_mappings, wk_mappings = pcall(extend_table, "error", nvimtree_mappings, package_info, telescope_mappings)

if has_mappings then
  return wk_mappings
else
  if has_notify then
    local message = ".."
    if type(wk_mappings) == "string" then
      message = tostring(wk_mappings)
    elseif type(wk_mappings) == "table" then
      message = table.concat(wk_mappings, "\n")
    else
      message = tostring(wk_mappings)
    end

    notify(message, "error", {title = "Error with the keymaps"})
  end
end
