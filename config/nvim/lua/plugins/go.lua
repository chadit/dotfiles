-- go.lua

local show = vim.schedule_wrap(function(msg)
  local has_notify, notify = pcall(require, "plugins.notify")
  if has_notify then
    notify.notify_info(msg, "go")
  end
end)

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
            show("Formatting go file")
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

function M.dap_config()
  local has_dap_plugin, dap = pcall(require, "dap")
  if not has_dap_plugin then
    --------------------------
    -- Golang --
    --------------------------
    dap.adapters.delve = {
      type = "server",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
      },
    }

    -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
    dap.configurations.go = {
      {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "${file}",
      },
      {
        type = "delve",
        name = "Debug test", -- configuration for debugging test files
        request = "launch",
        mode = "test",
        program = "${file}",
      },
      -- works with go.mod packages and sub packages
      {
        type = "delve",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
      },
    }
  end
end

return M
