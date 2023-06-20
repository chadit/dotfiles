local fn = vim.fn
local execute = vim.api.nvim_command

local M = {}

M.install_packer = function()
  local directory = string.format("%s/site/pack/packer/start/", fn.stdpath("data"))
  fn.mkdir(directory, "p")
  local output = fn.system((string.format("git clone %s %s", "https://github.com/wbthomason/packer.nvim", directory .. "/packer.nvim")))
  print(output)
  print("Installing Packer")
  execute("packadd packer.nvim")
  print("Please restart NeoVim")
end

M.load_plugins = function()
  local has_packer, packer = pcall(require, "packer")
  if not has_packer then M.install_packer() end

  local has_notify = pcall(require, "notify")
  if has_notify then
    local config = {display = {non_interactive = true}}
    packer.init(config)
  else
    packer.init()
  end

  local use = require("plugins.utils").use
  packer.reset()

  -- Packer can manage itself
  use 'wbthomason/packer.nvim' -- A use-package inspired plugin manager for Neovim.

  -- colorschemes
  use "EdenEast/nightfox.nvim"
  use "fenetikm/falcon"
  use "sainnhe/gruvbox-material"
  --  themes
  -- use({'bluz71/vim-moonfly-colors', config = require("plugins.configs.moonfly").config()})

  -- tpope stuff
  use 'tpope/vim-sensible'
  use 'tpope/vim-markdown'
  use 'tpope/vim-repeat'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-rvm'

  use({
    "rcarriga/nvim-notify",
    opt = false,
    config = function()
      local notify = require("notify")
      notify.setup({background_colour = "#000000"})
      vim.notify = notify
    end
  })

  -- debug
  use "nvim-lua/plenary.nvim"

  -- auto complete AI
  use {'github/copilot.vim'} -- github copilot

  -- autocomplete
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/cmp-nvim-lua"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lsp-signature-help"
  use "hrsh7th/cmp-path"
  use {"L3MON4D3/LuaSnip", requires = {"saadparwaiz1/cmp_luasnip"}, config = function() require("luasnip.loaders.from_lua").load({paths = "~/.snippets"}) end}

  -- lsp
  use "williamboman/mason.nvim"
  use "neovim/nvim-lspconfig"
  use {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    dependencies = {"williamboman/mason.nvim"},
    config = function() ---
      local has_mason, mason = pcall(require, "mason")
      if not has_mason then return end

      mason.setup()

      local has_masonlspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
      if not has_masonlspconfig then
        print("mason-lspconfig not found")
        return
      end

      local lspconfig = require('lspconfig')

      mason_lspconfig.setup({
        PATH = "prepend",
        ensure_installed = { --
          "bashls",
          -- "csharp_ls",
          "eslint",
          "gopls",
          "golangci_lint_ls",
          "marksman",
          "pyright",
          "lua_ls",
          -- "marksman",
          "terraformls",
          "tflint",
          "rust_analyzer",
          "tsserver",
          "solargraph",
          "yamlls"
        }
      })

      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            on_attach = function(client, bufnr)
              require("settings/shared").on_attach(client, bufnr)
              require("illuminate").on_attach(client)

              if server_name == "terraformls" then require("treesitter-terraform-doc").setup() end
            end
          })
        end
      })

      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

      mason_lspconfig.setup_handlers({
        function(server_name) -- Default handler
          lspconfig[server_name].setup {capabilities = capabilities}
        end,
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  -- Tells Lua that a global variable named vim exists to not have warnings when configuring neovim
                  globals = {"vim", "Player", "TensorCore"}
                }
              }
            }
          })
        end
      })

    end
  }

  -- williamboman/nvim-lsp-installer deprecated and replaced with mason.nvim
  -- use "williamboman/nvim-lsp-installer"

  use "Afourcat/treesitter-terraform-doc.nvim" -- opens Terraform resource docs

  use {"j-hui/fidget.nvim", config = function() require("fidget").setup() end}
  use {"folke/trouble.nvim", config = function() require("trouble").setup() end}
  use({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim", -- See also: https://github.com/Maan2003/lsp_lines.nvim
    config = function()
      require("lsp_lines").setup()

      -- disable virtual_text since it's redundant due to lsp_lines.
      vim.diagnostic.config({virtual_text = false})
    end
  })
  use {"simrat39/symbols-outline.nvim", config = function() require("symbols-outline").setup({auto_close = true}) end}
  use {"kosayoda/nvim-lightbulb", requires = {"antoinemadec/FixCursorHold.nvim"}}
  use "folke/lsp-colors.nvim"
  use "mfussenegger/nvim-lint"
  use "weilbith/nvim-code-action-menu"
  use {"simrat39/rust-tools.nvim", requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}}
  use "lvimuser/lsp-inlayhints.nvim" -- rust-tools already provides this feature, but gopls doesn't

  -- use {"nvim-lua/lsp-status.nvim"} -- A statusline component for the LSP client
  -- use("ray-x/lsp_signature.nvim") -- lsp signature hint when you type
  -- use 'nvim-lua/lsp_extensions.nvim' -- LSP extensions for nvim
  -- use 'glepnir/lspsaga.nvim' -- A light-weight lsp plugin based on neovim built-in lsp with highly a performant UI.

  -- ------------------------------------------------------------------------------

  use 'rust-lang/rust.vim' -- Rust language support for Vim/Neovim
  use 'onsails/lspkind-nvim' -- vscode-like pictograms for neovim lsp completion items

  -- linting and fixing
  use 'dense-analysis/ale'

  -- QuickFix
  use 'kevinhwang91/nvim-bqf'

  -- Telescope
  use 'nvim-lua/popup.nvim'
  use({"nvim-telescope/telescope.nvim", requires = {{'nvim-lua/plenary.nvim'}}})
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}
  use({"nvim-telescope/telescope-fzy-native.nvim"})
  use({"nvim-telescope/telescope-media-files.nvim"})
  use({"jvgrootveld/telescope-zoxide"})
  use {"nvim-telescope/telescope-ui-select.nvim", config = function() require("telescope").setup({pickers = {find_files = {hidden = true}, grep_string = {hidden = true}}}) end}
  use "kyoh86/telescope-windows.nvim"
  use "crispgm/telescope-heading.nvim"
  use "xiyaowong/telescope-emoji.nvim"
  use "axkirillov/telescope-changed-files"

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter", -- Nvim Treesitter configurations and abstraction layer
    run = ":TSUpdate",
    config = require("plugins.configs.treesitter").config()
  })
  use({"nvim-treesitter/nvim-treesitter-refactor"}) -- Refactor module for nvim-treesitter
  use({"nvim-treesitter/nvim-treesitter-textobjects", branch = "0.5-compat"}) -- Create your own textobjects using tree-sitter queries!
  -- buffer scroll context
  use {"nvim-treesitter/nvim-treesitter-context", requires = "nvim-treesitter/nvim-treesitter", config = function() require("treesitter-context").setup({separator = "-"}) end}
  use({"windwp/nvim-ts-autotag"}) -- Use treesitter to auto close and auto rename html tag
  use({"JoosepAlviste/nvim-ts-context-commentstring"}) -- Neovim treesitter plugin for setting the commentstring based on the cursor location in a file.
  use {"m-demare/hlargs.nvim", requires = {"nvim-treesitter/nvim-treesitter"}, config = function() require("hlargs").setup() end}

  -- pattern searching
  use "mileszs/ack.vim"

  -- search indexer
  use {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require('hlslens').setup()

      local kopts = {noremap = true, silent = true}

      vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

      vim.api.nvim_set_keymap('n', '<Leader>l', ':noh<CR>', kopts)
    end
  }

  use {
    "haya14busa/vim-asterisk",
    config = function()
      vim.api.nvim_set_keymap('n', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap('n', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap('n', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap('n', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})

      vim.api.nvim_set_keymap('x', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap('x', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap('x', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
      vim.api.nvim_set_keymap('x', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})
    end
  }

  -- search and replace
  use {"nvim-pack/nvim-spectre", requires = {"nvim-lua/plenary.nvim"}}

  -- debugging
  -- DAP
  use 'mfussenegger/nvim-dap'
  use {
    "rcarriga/nvim-dap-ui",
    requires = {"mfussenegger/nvim-dap"},
    config = function() --
      -- require("dapui").setup({
      --   icons = {expanded = "▾", collapsed = "▸", current_frame = "▸"},
      --   mappings = {
      --     -- Use a table to apply multiple mappings
      --     expand = {"<CR>", "<2-LeftMouse>"},
      --     open = "o",
      --     remove = "d",
      --     edit = "e",
      --     repl = "r",
      --     toggle = "t"
      --   },
      --   expand_lines = vim.fn.has("nvim-0.7") == 1,
      --   layouts = {
      --     { -- 
      --       open_on_start = true,
      --       elements = {
      --         { --
      --           id = "scopes",
      --           size = 0.25
      --         },
      --         "breakpoints",
      --         "stacks",
      --         "watches"
      --       },
      --       width = 40,
      --       position = "left"
      --     },
      --     {
      --       elements = { --
      --         elements = {"repl", "console"}
      --       },
      --       size = 0.25,
      --       position = "bottom"
      --     }
      --   },
      --   controls = {
      --     -- Requires Neovim nightly (or 0.8 when released)
      --     enabled = true,
      --     -- Display controls in this element
      --     element = "repl",
      --     icons = {pause = "", play = "", step_into = "", step_over = "", step_out = "", step_back = "", run_last = "↻", terminate = "□"}
      --   },
      --   floating = {
      --     max_height = nil, -- These can be integers or a float between 0 and 1.
      --     max_width = nil, -- Floats will be treated as percentage of your screen.
      --     border = "single", -- Border style. Can be "single", "double" or "rounded"
      --     mappings = {close = {"q", "<Esc>"}}
      --   },
      --   windows = {indent = 1},
      --   render = {
      --     max_type_length = nil, -- Can be integer or nil.
      --     max_value_lines = 100 -- Can be integer or nil.
      --   }
      -- })
    end
  }
  use {"leoluz/nvim-dap-go", requires = {"mfussenegger/nvim-dap"}, run = "go install github.com/go-delve/delve/cmd/dlv@latest", config = function() require("dap-go").setup() end}
  use {"theHamsta/nvim-dap-virtual-text", requires = {"mfussenegger/nvim-dap"}, config = function() require("nvim-dap-virtual-text").setup() end}
  use {'nvim-telescope/telescope-dap.nvim'}
  use {'mfussenegger/nvim-dap-python'} -- Python
  use {'Pocco81/DAPInstall.nvim'}
  use {'jbyuki/one-small-step-for-vimkind'}

  -- Coding
  --- nvim-go
  use {'crispgm/nvim-go'}
  -- vim-go
  use {'fatih/vim-go', run = ':GoUpdateBinaries', ft = {'go', 'gomod'}}

  -- Debugging
  use {'nvim-telescope/telescope-vimspector.nvim'}
  use 'sebdah/vim-delve' -- Go debugger: delve.
  -- use({"jose-elias-alvarez/nvim-lsp-ts-utils"}) -- Utilities to improve the TypeScript development experience for Neovim's built-in LSP client.
  use 'ludovicchabant/vim-gutentags'
  use {"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"}

  use 'numtostr/FTerm.nvim'
  use 'cespare/vim-toml' -- Vim syntax for TOML: https://github.com/cespare/vim-toml
  use 'tmhedberg/SimpylFold' -- Python folding: https://github.com/tmhedberg/SimpylFold
  use 'dart-lang/dart-vim-plugin' -- Flutter / Dart: https://github.com/dart-lang/dart-vim-plugin
  use 'hashivim/vim-terraform' -- Terraform: https://github.com/hashivim/vim-terraform

  -- Latex
  use 'lervag/vimtex'

  -- Ruby
  use 'thoughtbot/vim-rspec' -- RSpec support for Vim

  -- Lua development
  use {'folke/lua-dev.nvim'}
  use {'mhartington/formatter.nvim'}

  -- editing
  use 'andymass/vim-matchup'
  use 'windwp/nvim-autopairs'

  -- Git
  use({
    "lewis6991/gitsigns.nvim", -- Git signs written in pure lua
    requires = {"nvim-lua/plenary"},
    config = require("plugins.configs.gitsigns").config()
  })

  -- git history
  use {"sindrets/diffview.nvim", requires = {"nvim-lua/plenary.nvim"}}

  -- highlighters and indicators
  use {
    "RRethy/vim-illuminate", -- word usage highlighter
    config = function() end
  }
  use {
    "jinh0/eyeliner.nvim", -- jump to word indictors
    config = function()
      vim.api.nvim_set_hl(0, "EyelinerPrimary", {underline = true})
      vim.api.nvim_create_autocmd("ColorScheme", {pattern = {"*"}, callback = function() vim.api.nvim_set_hl(0, "EyelinerPrimary", {underline = true}) end})
    end
  }
  use "DanilaMihailov/beacon.nvim" -- cursor movement highlighter

  -- modify surrounding characters
  use({"kylechui/nvim-surround", config = function() require("nvim-surround").setup() end})

  -- highlight yanked region
  use "machakann/vim-highlightedyank"

  -- move lines around
  use "matze/vim-move"

  -- suggest mappings
  use {"folke/which-key.nvim", config = function() require("which-key").setup() end}

  -- display hex colours
  use {"norcalli/nvim-colorizer.lua", config = function() require("colorizer").setup() end}

  -- Icons
  use 'kyazdani42/nvim-web-devicons' -- lua `fork` of vim-web-devicons for neovim
  use 'ryanoasis/vim-devicons'

  -- Explorer
  use({
    "kyazdani42/nvim-tree.lua",
    branch = 'master', -- A file explorer tree for neovim written in lua
    config = require("plugins.configs.nvimtree").config(),
    requires = "kyazdani42/nvim-web-devicons"
  })

  use({
    "akinsho/nvim-bufferline.lua", -- A snazzy bufferline for Neovim
    requires = "kyazdani42/nvim-web-devicons",
    config = require("plugins.configs.bufferline").config()
  })
  use {
    'nvim-lualine/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = require("plugins.configs.lualine").config()
    --
  }

  -- code comments
  use "b3nj5m1n/kommentary"

  -- Keep things up to date
  execute("PackerSync")
end

return M
