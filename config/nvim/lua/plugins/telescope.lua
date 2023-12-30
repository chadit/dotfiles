-- telescope.lua

local M = {}

function M.new()
  return {
    -- Fuzzy Finder (files, lsp, etc)
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        -- Fuzzy Finder Algorithm which requires local dependencies to be built.
        -- Only load if `make` is available. Make sure you have the system
        -- requirements installed.
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = "make",
          cond = function()
            return vim.fn.executable("make") == 1
          end,
        },
        "nvim-telescope/telescope-file-browser.nvim",
      },
    },
    {
      "nvim-telescope/telescope-ui-select.nvim",
      dependencies = {
        "nvim-telescope/telescope.nvim",
      },
      config = function()
        local has_plugin, plg = pcall(require, "telescope")
        if not has_plugin then
          return
        end

        plg.setup({
          pickers = {
            find_files = {
              hidden = true,
            },
          },

          extenstions = {
            smart_open = {
              show_scores = false,
              ignore_patterns = { "node_modules", "*.git/*", "*/tmp/*" },
              match_algorithm = "fzf",
              disable_devicons = false,
              cwd_only = false,
            },
            fzf = {
              fuzzy = true, -- false will only do exact matching
              override_generic_sorter = false,
              override_file_sorter = true,
              case_mode = "smart_case", -- or "ignore_case" or "respect_case"
              -- the default case_mode is "smart_case"
            },
            ["ui-select"] = {
              require("telescope.themes").get_dropdown({}),
            },
            file_browser = {
              hijack_netrw = true,
            },
          },
        })

        plg.load_extension("ui-select")
        plg.load_extension("fzf")
        plg.load_extension("file_browser")
      end,
    },
  }
end

-- post install hook
function M.setup()
  -- Enable telescope fzf native, if installed
  pcall(require("telescope").load_extension, "fzf")
end

function M.keymaps()
  local has_plugin, plg = pcall(require, "telescope.builtin")
  if not has_plugin then
    return
  end

  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }
  map("n", "<leader>ta", function()
    require("telescope.builtin").find_files({
      prompt_title = "All Files",
    })
  end, vim.tbl_extend("force", opts, { desc = "All files" }))

  vim.keymap.set("n", "<leader>tg", plg.live_grep, {})
end

return M
