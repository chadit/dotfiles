-- go.lua

local M = {}

function M.new()
  return {
    -- gopher
    {
      "olexsmir/gopher.nvim",
      dependencies = {
        "leoluz/nvim-dap-go"
      },
      lazy = false,
      config = function()
        local gopher = require("gopher")
        gopher.setup({
          commands = {
            go = "go",
            gomodifytags = "gomodifytags",
            gotests = "gotests",
            impl = "impl",
            iferr = "iferr",
            dlv = "dlv",
          },
          goimport = "gopls",
          gofmt = "gopls",
        })
      end
    },
    -- go
    {
      "ray-x/go.nvim",
      enabled = true,
      dependencies = { -- optional packages
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
        "leoluz/nvim-dap-go"
      },
      config = function()
        require("go").setup({
          icons = { breakpoint = '🧘', currentpos = '🏃' }, -- setup to `false` to disable icons setup
          lsp_inlay_hints = {
            enable = false
          }
        })

        local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = "*.go",
          callback = function()
            require('go.format').goimport() -- goimport + gofmt
            --vim.lsp.buf.format({ async = true }) -- format only
          end,
          group = format_sync_grp
        })

        vim.cmd("autocmd FileType go nmap <Leader><Leader>l GoLint")
        vim.cmd("autocmd FileType go nmap <Leader>gc :lua require('go.comment').gen()")
      end,
      event = { "CmdlineEnter" },
      ft = { "go", 'gomod' },
      build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
  }
end

return M
