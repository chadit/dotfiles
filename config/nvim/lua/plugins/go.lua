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
      ft = { "go", "gomod" },
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
      end,
      build = function()
        vim.cmd [[silent! GoInstallDeps]]
      end,
    },
    -- go
    {
      "ray-x/go.nvim",
      dependencies = { -- optional packages
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
        'rcarriga/nvim-dap-ui',
        "mfussenegger/nvim-dap", -- Debug Adapter Protocol
        'theHamsta/nvim-dap-virtual-text',
        "leoluz/nvim-dap-go"
      },
      -- https://github.com/v36372/nvim/blob/91f739e6f321c2648253422744f442959489b606/lua/core/plugins/go.lua#L2
      config = function()
        local icons = require("utils.icons")

        require("go").setup({
          go = "go",                  -- go, can be go[default] or go1.18beta1
          goimports = "gopls",        -- goimport command, can be gopls[default] or goimport
          fillstruct = "gopls",       -- can be nil (use fillstruct, slower) and gopls
          gofmt = "gofumpt",          -- gofmt cmd,
          build_tags = "-v -cover -race -count=1 -test.failfast -benchtime=5s -timeout=3s",
          test_runner = "go",         -- richgo, go test, richgo, dlv, ginkgo
          verbose_tests = true,       -- set to add verbose flag to tests deprecated, see '-v' option
          run_in_floaterm = true,     -- set to true to run in a float window. :GoTermClose closes the floatterm
          -- float term recommend if you use richgo/ginkgo with terminal color
          floaterm = {                -- position
            posititon = 'auto',       -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
            width = 0.45,             -- width of float window if not auto
            height = 0.98,            -- height of float window if not auto
            title_colors = 'dracula', -- default to nord, one of {'nord', 'tokyo', 'dracula', 'rainbow', 'solarized ', 'monokai'}
            -- can also set to a list of colors to define colors to choose from
            -- e.g {'#D8DEE9', '#5E81AC', '#88C0D0', '#EBCB8B', '#A3BE8C', '#B48EAD'}
          },
          icons = { breakpoint = icons.ui.Yoga, currentpos = icons.ui.RunningMan }, -- setup to `false` to disable icons setup
          lsp_cfg = true,                                                           -- true: use non-default gopls setup specified in go/lsp.lua
          lsp_gofumpt = true,                                                       -- true: set default gofmt in gopls format to gofumpt
          lsp_codelens = true,                                                      -- set to false to disable codelens, true by default
          -- lsp_keymaps = false, -- set to false to disable gopls/lsp keymap
          -- diagnostic = {
          --   underline = false,
          --   hdlr = true,                                                 -- hook lsp diag handler
          --   virtual_text = { space = 0, prefix = icons.arrows.Diamond }, -- virtual text setup
          --   signs = true,
          -- },
          lsp_diag_update_in_insert = true,
          lsp_document_formatting = true,
          -- set to true: use gopls to format
          -- false if you want to use other formatter tool(e.g. efm, nulls)
          lsp_inlay_hints = {
            enable = false,
            -- Only show inlay hints for the current line
            only_current_line = false,
          },
          -- gopls_cmd = nil,          -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
          -- gopls_remote_auto = true, -- add -remote=auto to gopls
          -- gocoverage_sign = "█",

          luasnip = true,
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

        --vim.cmd("autocmd FileType go nmap <Leader><Leader>l GoLint")
        -- vim.cmd("autocmd FileType go nmap <Leader>gc :lua require('go.comment').gen()")
      end,
      event = { "CmdlineEnter" },
      ft = { "go", 'gomod' },
      build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
  }
end

function M.dap_config()
  local has_dap_plugin, dap = pcall(require, "dap")
  if not has_dap_plugin then return end

  require("dap-go").setup({
    dap_configurations = {
      {
        -- Must be "go" or it will be ignored by the plugin
        type = "go",
        name = "Attach remote",
        mode = "remote",
        request = "attach",
      },
    },

    -- delve configurations
    delve = {
      -- the path to the executable dlv which will be used for debugging.
      -- by default, this is the "dlv" executable on your PATH.
      path = "dlv",
      -- time to wait for delve to initialize the debug session.
      -- default to 20 seconds
      initialize_timeout_sec = 20,
      -- a string that defines the port to start delve debugger.
      -- default to string "${port}" which instructs nvim-dap
      -- to start the process in a random available port
      port = "${port}",
      -- additional args to pass to dlv
      args = {},
      -- the build flags that are passed to delve.
      -- defaults to empty string, but can be used to provide flags
      -- such as "-tags=unit" to make sure the test suite is
      -- compiled during debugging, for example.
      -- passing build flags using args is ineffective, as those are
      -- ignored by delve in dap mode.
      build_flags = "",
    },
  })

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

return M
