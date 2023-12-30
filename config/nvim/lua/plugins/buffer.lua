-- buffer.lua

local M = {}

function M.new()
  return {
    {
      "akinsho/bufferline.nvim",
      version = "*",
      dependencies = "nvim-web-devicons",
      config = function()
        local has_plugin, plg = pcall(require, "bufferline")
        if not has_plugin then
          return
        end

        plg.setup({
          options = {
            numbers = "buffer_id",
            tab_size = 16,
            diagnostics = "nvim_lsp",
            ---@diagnostic disable-next-line: unused-local
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
              local icon = level:match("error") and " " or " "
              return " " .. icon .. count
            end,
            offsets = {
              {
                filetype = "neo-tree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left",
              },
            },
          },
        })
      end,
    },
  }
end

return M
