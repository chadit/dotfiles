-- rust.lua

local function get_codelldb()
  local mason_registry = require("mason-registry")
  local codelldb = mason_registry.get_package("codelldb")
  local extension_path = codelldb:get_install_path() .. "/extension/"

  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = ""
  if vim.loop.os_uname().sysname:find("Windows") then
    liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
  elseif vim.fn.has("mac") == 1 then
    liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
  else
    liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  end

  return codelldb_path, liblldb_path
end

local M = {}

function M.new()
  return {
    {
      "simrat39/rust-tools.nvim",
      ft = { "rust" },
      event = { "BufReadPost *.rs" },
      dependencies = {
        "rust-lang/rust.vim", -- syntax highlighting
        "neovim/nvim-lspconfig", -- lsp support
        "nvim-lua/plenary.nvim", -- debugging support
        "mfussenegger/nvim-dap", -- debugging support
      },
      opts = {
        on_attach = function(_, bufnr)
          -- Hover actions
          vim.keymap.set(
            "n",
            "<C-space>",
            require("rust-tools").hover_actions.hover_actions,
            { buffer = bufnr }
          )
          -- Code action groups
          vim.keymap.set(
            "n",
            "<Leader>a",
            require("rust-tools").code_action_group.code_action_group,
            { buffer = bufnr }
          )
        end,
        settings = {
          ["rust-analyzer"] = {
            linkedProjects = { "./Cargo.toml", "./rust/Cargo.toml" },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
  }
end

function M.dap_config()
  local codelldb_path, liblldb_path = get_codelldb()
  local lsp_utils = require("utils.lsp")
  local opts = lsp_utils.opts("rust-tools.nvim")

  local has_dap_plugin, dap = pcall(require, "dap")
  if not has_dap_plugin then
    --------------------------
    -- C/C++ --
    --------------------------
    dap.adapters.lldb = {
      type = "executable",
      command = "/opt/homebrew/opt/llvm/bin/lldb-vscode", -- adjust as needed, must be absolute path
      name = "lldb",
    }

    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
          ---@diagnostic disable-next-line: redundant-parameter
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
      },
    }

    dap.configurations.c = dap.configurations.cpp
  end

  -- load after plugs are installed.
  if opts and not opts.capabilities then
    opts.capabilities = lsp_utils.capabilities()
  end

  lsp_utils.on_attach(function(client, bufnr)
    local map = function(mode, lhs, rhs, desc)
      if desc then
        desc = desc
      end
      vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
    end
    -- stylua: ignore
    if client.name == "rust_analyzer" then
      map("n", "<leader>le", "<cmd>RustRunnables<cr>", "Runnables")
      map("n", "<leader>ll", function() vim.lsp.codelens.run() end, "Code Lens")
      map("n", "<leader>lt", "<cmd>Cargo test<cr>", "Cargo test")
      map("n", "<leader>lR", "<cmd>Cargo run<cr>", "Cargo run")
    end
  end)

  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "Cargo.toml" },
    callback = function(event)
      local bufnr = event.buf

      -- Register keymappings
      local wk = require("which-key")
      local keys = { mode = { "n", "v" }, ["<leader>lc"] = { name = "+Crates" } }
      wk.register(keys)

      local map = function(mode, lhs, rhs, desc)
        if desc then
          desc = desc
        end
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
      end
      map("n", "<leader>lcy", "<cmd>lua require'crates'.open_repository()<cr>", "Open Repository")
      map("n", "<leader>lcp", "<cmd>lua require'crates'.show_popup()<cr>", "Show Popup")
      map("n", "<leader>lci", "<cmd>lua require'crates'.show_crate_popup()<cr>", "Show Info")
      map("n", "<leader>lcf", "<cmd>lua require'crates'.show_features_popup()<cr>", "Show Features")
      map("n", "<leader>lcd", "<cmd>lua require'crates'.show_dependencies_popup()<cr>", "Show Dependencies")

      map("n", "<leader>lcld", "<Cmd>lua vim.lsp.codelens.refresh()<CR>", "Refresh CodeLens")
      map("n", "<leader>lclr", "<Cmd>lua vim.lsp.codelens.run()<CR>", "Run Test")
    end,
  })

  require("rust-tools").setup({
    tools = {
      autoSetHints = true,
      runnables = { use_telescope = true },
      inlay_hints = {
        -- auto = false,
        show_parameter_hints = false,
        parameter_hints_prefix = " <-",
        other_hints_prefix = "» ",
      },
      hover_actions = { border = "solid" },
      on_initialized = function()
        vim.api.nvim_create_autocmd(
          { "BufReadPost", "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" },
          {
            pattern = { "*.rs" },
            callback = function()
              vim.lsp.codelens.refresh()
            end,
          }
        )
      end,
    },
    server = opts,
    dap = {
      adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
    },
  })
  return true
end

return M
