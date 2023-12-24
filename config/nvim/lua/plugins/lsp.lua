-- lsp.lua

local show = vim.schedule_wrap(function(msg)
  local has_notify, notify = pcall(require, "plugins.notify")
  if has_notify then
    notify.notify_info(msg, "ensure-tools")
  end
end)

local events = {
  BufEnter = "BufEnter",
  BufRead = "BufRead",
  UIEnter = "UIEnter",
  InsertEnter = "InsertEnter",
  VeryLazy = "VeryLazy",
}

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
  "delve", -- go
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
  "buf",
  "gofumpt",
  "goimports",
  "golines",
  "gomodifytags",
  "gotests",
  "jq",
  "luaformatter",
  "markdownlint",
  "prettier",
  "rubocop",
  "rubyfmt",
  "yamlfmt"
}

--local servers = {
--   gopls = {
--     settings = {
--       gopls = {
--         hints = {
--           assignVariableTypes = true,
--           compositeLiteralFields = true,
--           compositeLiteralTypes = true,
--           constantValues = true,
--           functionTypeParameters = true,
--           parameterNames = true,
--           rangeVariableTypes = true,
--         },
--         semanticTokens = true,
--       },
--     },
--   },
--   html = {},
--   jsonls = {
--     settings = {
--       json = {
--         schemas = require("schemastore").json.schemas(),
--       },
--     },
--   },
--   pyright = {
--     settings = {
--       python = {
--         analysis = {
--           typeCheckingMode = "off",
--           autoSearchPaths = true,
--           useLibraryCodeForTypes = true,
--           diagnosticMode = "workspace",
--         },
--       },
--     },
--   },
--   -- pylsp = {}, -- Integration with rope for refactoring - https://github.com/python-rope/pylsp-rope
-- rust_analyzer = {
--   settings = {
--     ["rust-analyzer"] = {
--       cargo = { allFeatures = true },
--       checkOnSave = {
--         command = "cargo clippy",
--         extraArgs = { "--no-deps" },
--       },
--     },
--   },
-- },
--   lua_ls = {
--     settings = {
--       Lua = {
--         runtime = {
--           -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--           version = "LuaJIT",
--           -- Setup your lua path
--           path = vim.split(package.path, ";"),
--         },
--         diagnostics = {
--           -- Get the language server to recognize the `vim` global
--           globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins", "MiniTest" },
--           -- disable = { "lowercase-global", "undefined-global", "unused-local", "unused-vararg", "trailing-space" },
--         },
--         workspace = {
--           checkThirdParty = false,
--         },
--         completion = { callSnippet = "Replace" },
--         telemetry = { enable = false },
--         hint = {
--           enable = false,
--         },
--       },
--     },
--   },
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
--}

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

-- local function fetch_config(tool_name, extra_opts)
--   if not tool_name then return {} end

--   --local mason_registry = require("mason-registry")

--   -- Package installation folder
--   local install_root_dir = vim.fn.stdpath "data" .. "/mason"

--   if tool_name == "rust_analyzer" then
--     show("fetch_config: " .. tool_name .. ", install_root_dir: " .. install_root_dir)

--     local server_settings = {}
--     if servers["rust_analyzer"] then server_settings = servers["rust_analyzer"] end

--     local opts = vim.tbl_deep_extend("force", extra_opts, server_settings or {})

--     -- DAP settings - https://github.com/simrat39/rust-tools.nvim#a-better-debugging-experience
--     -- local extension_path = install_root_dir .. "/packages/codelldb/extension/"
--     -- local codelldb = mason_registry.get_package("codelldb")
--     -- local extension_path = codelldb:get_install_path() .. "/extension/"

--     -- local codelldb_path = extension_path .. "adapter/codelldb"
--     -- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
--     -- local ih = require "inlay-hints"

--     return {
--       tools = {
--         -- executor = require("rust-tools/executors").toggleterm,
--         hover_actions = { border = "solid" },
--         on_initialized = function()
--           vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
--             pattern = { "*.rs" },
--             callback = function()
--               vim.lsp.codelens.refresh()
--             end,
--           })
--           -- ih.set_all()
--         end,
--         -- inlay_hints = {
--         --   auto = false,
--         -- },
--       },
--       server = opts,
--       -- dap = {
--       --   adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
--       -- },
--     }
--   end

--   return {}
-- end

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
      event = events.InsertEnter,
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
        require("mason").setup()
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

            -- disable virtual_text since it's redundant due to lsp_lines.
            vim.diagnostic.config({ virtual_text = false })
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
        { "rcarriga/nvim-dap-ui" },
        { "theHamsta/nvim-dap-virtual-text" },
      },
    },
  }
end

function M.setup()
  local has_dap_plugin, dap = pcall(require, "dap")
  if not has_dap_plugin then return end

  local has_dapui_plugin, dapui = pcall(require, "dapui")
  if not has_dapui_plugin then return end

  dapui.setup()

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end

  require "plugins.rust".dap_config()
end

function M.keymaps()
  vim.keymap.set("n", "<Leader>dt", ':DapToggleBreakpoint<CR>')
  vim.keymap.set("n", "<Leader>dx", ':DapTerminate<CR>')
  vim.keymap.set("n", "<Leader>do", ':DapStepOver<CR>')
end

return M
