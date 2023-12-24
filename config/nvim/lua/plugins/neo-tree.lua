local function setup()
  local has_plugin, plg = pcall(require, "neo-tree")
  if not has_plugin then return end

  plg.setup({
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false,
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          ".DS_Store",
          "thumbs.db"
        },
      },
      hijack_netrw_behavior = "open_default",
      window = {
        mappings = {
          ['<leftrelease>'] = "open"
        }
      }

    },
    window = {
      position = "left",
      width = 30,
    },
  })

  -- Create an autocommand to open Neo-tree on Neovim startup
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    command = "Neotree"
  })
end

local M = {}

function M.new()
  return {
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      config = function()
        setup()
      end
    },
  }
end

function M.setup()
end

function M.keymaps()
  vim.keymap.set({ 'n', 'v' }, '<C-n>', ':Neotree toggle<CR>', {})
end

return M
