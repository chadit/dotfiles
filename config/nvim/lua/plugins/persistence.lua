-- persistence.lua

local M = { ignore = false }

function M.new()
  return {
    {
      "rmagatti/auto-session",
      -- opts = {
      --   -- add any custom options here
      -- },
      config = function()
        local has_plugin, plg = pcall(require, "auto-session")
        if not has_plugin then
          return
        end

        plg.setup({
          log_level                        = "error",
          auto_save_enabled                = true,
          auto_restore_enabled             = true,
          auto_session_create_enabled      = false,

          auto_session_root_dir            = vim.fn.stdpath("data") .. "/sessions/",
          auto_session_suppress_dirs       = { "~/", "~/Downloads", "/" },
          auto_session_enable_last_session = true,
          auto_session_enabled             = true,
          bypass_session_save_file_types   = { "alpha", "neo-tree" },
        })
      end
    }
  }
end

function M.keymaps()
  -- add any keymaps here
end

return M
