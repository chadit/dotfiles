-- lsp.lua

-- Functional wrapper for mapping custom keybindings
-- mode (as in Vim modes like Normal/Insert mode)
-- lhs (the custom keybinds you need)
-- rhs (the commands or existing keybinds to customise)
-- opts (additional options like <silent>/<noremap>, see :h map-arguments for more info on it)
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local show = vim.schedule_wrap(function(msg)
  local has_notify, notify = pcall(require, "plugins.notify")
  if has_notify then
    notify.notify_info(msg, "ensure-tools")
  end
end)

-- -- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
local ensure_language_servers = {
  -- LSP
  "ansiblels",
  "bashls",
  "bufls",
  "clangd",
  -- "csharp_ls",
  "cmake",
  "cssls",
  "dockerls",
  "docker_compose_language_service",
  "eslint",
  "golangci_lint_ls",
  "gopls",
  "html",
  "htmx",
  "helm_ls",
  "jsonls",
  "jqls",
  "lua_ls",
  "marksman",
  "pyright",
  "rust_analyzer",
  "solargraph",
  "terraformls",
  "tsserver",
  "yamlls",
}

local ensure_tools = {
  -- Dap
  "codelldb", -- rust
  "cpptools", -- c/c++/rust
  "bash-debug-adapter",
  "chrome-debug-adapter",
  "debugpy", -- python
  "delve",   -- go
  "elixir-ls",
  "go-debug-adapter",
  "js-debug-adapter",

  -- Linters
  "ansible-lint",
  "buf",
  "eslint_d",
  "golangci-lint",
  "jsonlint",
  "luacheck",
  "markdownlint",
  "pylint",
  "yamllint",
  -- Formatter
  "black",
  "buf",
  "gofumpt",
  "goimports",
  "golines",
  "gomodifytags",
  "gotests",
  "isort",
  "jq",
  "luaformatter",
  "markdownlint",
  "prettier",
  "rubocop",
  "rubyfmt",
  "yamlfmt"
}

local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
  { name = "DapBreakpoint", text = "🔴" },
  { name = "DapStopped", text = "▶️" },
  -- { name = "DapUIPlay", text = "▶️" },
  -- { name = "DapUIPause", text = "⏸" },
  -- { name = "DapUIStop", text = "⏹" },
  -- { name = "DapUIRewind", text = "⏪" },
  -- { name = "DapUIFastForward", text = "⏩" },
  -- { name = "DapUIFrame", text = "🔲" },
  -- { name = "DapUIBreakpoint", text = "🔴" },
}

local servers = {
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        semanticTokens = true,
        analyses = {
          fieldalignment = true,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
          shadow = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      },
    },
  },
  --   html = {},
  --   jsonls = {
  --     settings = {
  --       json = {
  --         schemas = require("schemastore").json.schemas(),
  --       },
  --     },
  --   },
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- Setup your lua path
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins", "MiniTest" },
          -- disable = { "lowercase-global", "undefined-global", "unused-local", "unused-vararg", "trailing-space" },
        },
        workspace = {
          checkThirdParty = false,
        },
        completion = { callSnippet = "Replace" },
        telemetry = { enable = false },
        hint = {
          enable = false,
        },
      },
    },
  },
  --   tsserver = {
  --     disable_formatting = true,
  --     settings = {
  --       javascript = {
  --         inlayHints = {
  --           includeInlayEnumMemberValueHints = true,
  --           includeInlayFunctionLikeReturnTypeHints = true,
  --           includeInlayFunctionParameterTypeHints = true,
  --           includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
  --           includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --           includeInlayPropertyDeclarationTypeHints = true,
  --           includeInlayVariableTypeHints = true,
  --         },
  --       },
  --       typescript = {
  --         inlayHints = {
  --           includeInlayEnumMemberValueHints = true,
  --           includeInlayFunctionLikeReturnTypeHints = true,
  --           includeInlayFunctionParameterTypeHints = true,
  --           includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
  --           includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  --           includeInlayPropertyDeclarationTypeHints = true,
  --           includeInlayVariableTypeHints = true,
  --         },
  --       },
  --     },
  --   },
  --   vimls = {},
  --   -- tailwindcss = {},
  --   yamlls = {
  --     schemastore = {
  --       enable = true,
  --     },
  --     settings = {
  --       yaml = {
  --         hover = true,
  --         completion = true,
  --         validate = true,
  --         schemas = require("schemastore").json.schemas(),
  --       },
  --     },
  --   },
  --   jdtls = {},
  --   dockerls = {},
  --   -- graphql = {},
  --   bashls = {},
  --   taplo = {},
  --   -- omnisharp = {},
  --   -- kotlin_language_server = {},
  --   -- emmet_ls = {},
  --   -- marksman = {},
  --   -- angularls = {},
  --   -- sqls = {
  --   -- settings = {
  --   --   sqls = {
  --   --     connections = {
  --   --       {
  --   --         driver = "sqlite3",
  --   --         dataSourceName = os.getenv "HOME" .. "/workspace/db/chinook.db",
  --   --       },
  --   --     },
  --   --   },
  --   -- },
  --   -- },
}

local function fetch_lsp_to_mason_list(tbl)
  if not tbl or #tbl == 0 then return nil end
  local ok_mlsp, mlsp = pcall(require, 'mason-lspconfig')
  if not ok_mlsp then
    return nil
  end

  local new_list = {}
  for _, name in ipairs(tbl) do
    local mason_name = mlsp.get_mappings().lspconfig_to_mason[name] or name
    if mason_name then
      new_list[#new_list + 1] = mason_name
    end
  end

  return new_list
end

local function fetch_config(tool_name, extra_opts)
  if not tool_name then return {} end

  local server_settings = {}
  if servers[tool_name] then server_settings = servers[tool_name] end
  local opts = vim.tbl_deep_extend("force", extra_opts, server_settings or {})

  return opts
end

local function check_tools(tbl)
  if not tbl or #tbl == 0 then return end

  require("mason-lspconfig").setup({
    automatic_installation = true,
    ensure_installed = ensure_language_servers,
  })

  local mr = require 'mason-registry'

  for _, name in ipairs(tbl) do
    local p = mr.get_package(name)
    if p then
      if p:is_installed() then
        local extra = ""
        local can_update = false

        p:check_new_version(function(ok, version)
          local version_type = type(version)
          if version_type == "string" then
            if not version == "Package is not outdated." then
              can_update = true
              extra = extra .. ", new_version_ok: " .. tostring(ok) .. ", new_version_string: " .. tostring(version)
            end
          elseif type(version) == "table" then
            local current_version = version["current_version"] or ""
            local latest_version = version["latest_version"] or ""
            if current_version ~= latest_version then
              can_update = true
              extra = extra ..
                  ", new_version_ok: " ..
                  tostring(ok) ..
                  ", current_version: " .. tostring(current_version) .. ", latest_version: " .. tostring(latest_version)
            end
          else
            local uf = require "utils.format"
            local version_string = uf.TableToString(version)
            extra = extra ..
                ", new_version_ok: " ..
                tostring(ok) .. ", type:" .. tostring(version_type) .. ", new_version: " .. version_string
          end
        end)

        if can_update then
          show(name .. " is being updated, extra:" .. extra)
          p:install({})
        end
      else
        show(name .. " is being installed")
        p:install({})
      end
    else
      show(name .. " package name is not found")
    end
  end
end

local M = {}

function M.new()
  return {
    { -- windwp/nvim-ts-autotag
      "windwp/nvim-ts-autotag",
      -- event = events.InsertEnter,
      config = function()
        local has_plugin, plg = pcall(require, "nvim-ts-autotag")
        if not has_plugin then return end
        plg.setup()
      end,
    },

    { -- williamboman/mason.nvim
      "williamboman/mason.nvim",
      build = function()
        pcall(function()
          require("mason-registry").refresh()
        end)
      end,
      config = function()
        require("mason").setup({
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗"
            }
          }
        })
      end,
    },

    { -- williamboman/mason-lspconfig.nvim
      "williamboman/mason-lspconfig.nvim",
      dependencies = {
        "williamboman/mason.nvim",
        "rcarriga/nvim-notify" -- not really a dependency but used for logging
      },
      config = function()
        check_tools(fetch_lsp_to_mason_list(ensure_language_servers))
        check_tools(fetch_lsp_to_mason_list(ensure_tools))
      end,
    },

    {
      "jose-elias-alvarez/null-ls.nvim",
      event = "BufReadPre",
      dependencies = "nvim-lua/plenary.nvim",
      config = function()
        local null_ls = require("null-ls")
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
        local formatting = null_ls.builtins.formatting
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
        local diagnostics = null_ls.builtins.diagnostics
        local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

        -- https://github.com/prettier-solidity/prettier-plugin-solidity
        null_ls.setup({
          debug = false,
          on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
              vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
              vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePre" }, {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({ bufnr = bufnr })
                end,
              })
            end
          end,
          sources = {
            formatting.prettier.with({
              extra_filetypes = { "toml" },
              extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
            }),
            formatting.black.with({ extra_args = { "--fast", "--line-length=120" } }),
            formatting.isort,
            formatting.stylua,
            formatting.gofmt,
            formatting.goimports,
            formatting.markdownlint,
            diagnostics.golangci_lint,
            diagnostics.markdownlint,
          },
        })
      end
    },

    { -- neovim/nvim-lspconfig
      "neovim/nvim-lspconfig",
      dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        -- A Neovim Lua plugin providing access to the SchemaStore catalog.
        "b0o/schemastore.nvim",
        "jose-elias-alvarez/null-ls.nvim",
        "hrsh7th/cmp-nvim-lsp",
        -- Extensible UI for Neovim notifications and LSP progress messages.
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { "j-hui/fidget.nvim", opts = {} },
        -- Additional lua configuration, makes nvim stuff amazing!
        { "folke/neodev.nvim", opts = {} },
        -- lsp_lines is a simple neovim plugin that renders diagnostics using virtual lines on top of the real line of code.
        {
          "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
          config = function()
            require("lsp_lines").setup()

            local diag_config = {
              -- disable virtual text
              virtual_text = false,
              -- show signs
              signs = {
                active = signs,
              },
              update_in_insert = true,
              underline = true,
              severity_sort = true,
              float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
                suffix = "",
              },
            }

            vim.diagnostic.config(diag_config)
          end
        },
        -- Adds LSP completion capabilities
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        -- rust tools
        "simrat39/rust-tools.nvim", "rust-lang/rust.vim",
      },
      event = { -- fixes an issue with lazy loading an running overlays.
        'BufReadPost *.go',
        'BufReadPost *.rs',
        'BufReadPost *.c',
        'BufReadPost *.gcc',
        'BufReadPost *.h',
        'BufReadPost *.ts',
        'BufReadPost *.js',
        'BufReadPost *.html',
      },
      config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            -- n = normal mode, K = shift + k, display honor info for word under cursor.
            -- these are dependent on the ev callback. cannot be moved to .keymaps()
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          end
        })
      end,
    },

    { -- folke/trouble.nvim
      "folke/trouble.nvim",
      cmd = {
        "Trouble",
        "TroubleToggle",
        "TroubleRefresh",
      },
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("trouble").setup({
          auto_open = true,           -- automatically open the list when you have diagnostics
          auto_close = true,          -- automatically close the list when you have no diagnostics
          use_diagnostic_signs = true -- enabling this will use the signs defined in your lsp client
        })
      end
    },

    { -- mfussenegger/nvim-dap
      "mfussenegger/nvim-dap",
      dependencies = {
        {
          "rcarriga/nvim-dap-ui",
          config = function()
            -- uses neodev to get type checking
            require("neodev").setup({
              library = { plugins = { "nvim-dap-ui" }, types = true },
            })
          end
        },
        { "theHamsta/nvim-dap-virtual-text" },
        { "mfussenegger/nvim-dap-python" },      -- for python
        { "nvim-telescope/telescope-dap.nvim" }, -- for telescope integration
      },
      config = function()
        local path = require('mason-registry').get_package('debugpy'):get_install_path()
        require('dap-python').setup(path .. '/venv/bin/python')
      end
    },
  }
end

function M.setup()
  local has_lspconfig, lspconfig = pcall(require, "lspconfig")
  if not has_lspconfig then
    return
  end

  -- load settings for each server
  for _, server_name in ipairs(ensure_language_servers) do
    if lspconfig[server_name] then
      -- load custom settings otherwise load defaults.
      if server_name == "rust_analyzer" then
        require "plugins.rust".dap_config()
      else
        local on_attach = function(client, bufnr)
          show("LSP attached for: " .. client.name)

          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format({
              async = true,
              filter = function(client1)
                return client1.name == "null-ls"
              end
            })
          end, bufopts)
        end

        local base_opt = { on_attach = on_attach }
        local opt = fetch_config(server_name, base_opt)
        lspconfig[server_name].setup(opt)

        if server_name == "gopls" then
          require("plugins.go").dap_config()
        elseif server_name == "bashls" then
          require("plugins.bash").dap_config()
        end
      end
    end
  end

  local has_dap_plugin, dap = pcall(require, "dap")
  if not has_dap_plugin then return end

  local has_dapui_plugin, dapui = pcall(require, "dapui")
  if not has_dapui_plugin then return end

  require("nvim-dap-virtual-text").setup()

  dapui.setup({
    expand_lines = true,
    icons = { expanded = "", collapsed = "", circular = "" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    layouts = {
      {
        elements = {
          { id = "scopes",      size = 0.33 },
          { id = "breakpoints", size = 0.17 },
          { id = "stacks",      size = 0.25 },
          { id = "watches",     size = 0.25 },
        },
        size = 0.33,
        position = "right",
      },
      {
        elements = {
          { id = "repl",    size = 0.45 },
          { id = "console", size = 0.55 },
        },
        size = 0.27,
        position = "bottom",
      },
    },
    floating = {
      max_height = 0.9,
      max_width = 0.5,             -- Floats will be treated as percentage of your screen.
      border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
  })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

function M.keymaps()
  map('n', '<F5>', '<cmd>lua require "dap".continue()<CR>', { silent = true, noremap = true })
  map('n', '<F10>', '<cmd>lua require "dap".step_over()<CR>', { silent = true, noremap = true })
  map('n', '<F11>', '<cmd>lua require "dap".step_into()<CR>', { silent = true, noremap = true })
  map('n', '<F12>', '<cmd>lua require "dap".step_out()<CR>', { silent = true, noremap = true })

  -- toggle a debug breakpoint
  map('n', '<leader>db', '<cmd>lua require "dap".toggle_breakpoint()<CR>', { silent = true, noremap = true })

  -- run the closes python run test
  vim.keymap.set('n', '<leader>dpr', ":lua require('dap-python').test_method()<CR>",
    { silent = true, noremap = true })

  -- run the python test class
  vim.keymap.set('n', '<leader>dpc', ":lua require('dap-python').test_class()<CR>",
    { silent = true, noremap = true })

  -- function() require('dap-python').debug_selection() end
  vim.keymap.set('n', '<leader>dps <ESC>', ":lua require('dap-python').debug_selection()<CR>",
    { silent = true, noremap = true })

  -- open dap gui
  vim.keymap.set('n', '<leader>dui', ":lua require('dapui').toggle()<CR>",
    { silent = true, noremap = true })

  vim.keymap.set('n', '<leader>du[', ":lua require('dapui').toggle(1)<CR>",
    { silent = true, noremap = true })

  vim.keymap.set('n', '<leader>du]', ":lua require('dapui').toggle(2)<CR>",
    { silent = true, noremap = true })
end

return M
