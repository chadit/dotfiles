-- telescope.lua

local M = {}

function M.new()
  return {
    -- Fuzzy Finder (files, lsp, etc)
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          -- NOTE: If you are having trouble with this installation,
          --       refer to the README for telescope-fzf-native for more instructions.
          build = 'make',
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
      },
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
      },
      config = function()
        require("telescope").setup({
          extenstions = {
            ["ui-select"] = {
              require("telescope.themes").get_dropdown({
                -- winblend = 10,
                -- border = true,
                -- previewer = false,
              })
            }
          }
        })

        require("telescope").load_extension("ui-select")
      end

    }
  }
end

-- post install hook
function M.setup()
  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'fzf')
end

function M.keymaps()
  local has_plugin, plg = pcall(require, "telescope.builtin")
  if not has_plugin then return end
  vim.keymap.set('n', '<C-p>', plg.find_files, {})
  vim.keymap.set('n', '<leader>fg', plg.live_grep, {})
end

return M
