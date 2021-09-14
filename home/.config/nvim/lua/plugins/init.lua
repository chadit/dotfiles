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

  use 'tpope/vim-sensible' -- Sensible defaults for Vim.

  use("rcarriga/nvim-notify") -- A fancy, configurable, notification manager for NeoVim

  -- LSP
  use {'neovim/nvim-lspconfig'} -- Quickstart configurations for the Nvim LSP client
  use {"nvim-lua/lsp-status.nvim"} -- A statusline component for the LSP client
  use {"folke/lsp-trouble.nvim", requires = {"kyazdani42/nvim-web-devicons"}}
  use 'nvim-lua/completion-nvim' -- Completion for the LSP client
  -- TODO: need to work on this more, keeps erroring on selene
  -- use("jose-elias-alvarez/null-ls.nvim") -- inject LSP diagnostics, code actions, and more via Lua
  use("ray-x/lsp_signature.nvim") -- lsp signature hint when you type
  use {"kosayoda/nvim-lightbulb"} -- Lightbulb for LSP
  use 'nvim-lua/lsp_extensions.nvim' -- LSP extensions for nvim
  use 'glepnir/lspsaga.nvim' -- A light-weight lsp plugin based on neovim built-in lsp with highly a performant UI.
  use({
    -- "williamboman/nvim-lsp-installer", -- TODO: need a config
    "kabouzeid/nvim-lspinstall", -- Install LSP Servers
    requires = "neovim/nvim-lspconfig"
  })
  use 'folke/lsp-colors.nvim'
  use({
    "folke/trouble.nvim", -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
    requires = "kyazdani42/nvim-web-devicons",
    config = require("plugins.trouble").config()
  })
  use {"simrat39/rust-tools.nvim", requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}}
  use 'rust-lang/rust.vim' -- Rust language support for Vim/Neovim
  use 'onsails/lspkind-nvim' -- vscode-like pictograms for neovim lsp completion items

  -- linting and fixing
  use 'dense-analysis/ale'

  -- QuickFix
  use 'kevinhwang91/nvim-bqf'

  -- Telescope
  use 'nvim-lua/popup.nvim' -- An implementation of the Popup API from vim in Neovim. Hope to upstream when complete
  use 'nvim-lua/plenary.nvim' -- plenary: full; complete; entire; absolute; unqualified.
  use({
    "nvim-telescope/telescope.nvim", -- Find, Filter, Preview, Pick. All lua, all the time.
    config = require("plugins.telescope").config()
  })

  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'} -- fzf-native is a c port of fzf. It only covers the algorithm and implements few functions to support calculating the score.
  use({
    "nvim-telescope/telescope-fzy-native.nvim" -- FZY style sorter that is compiled_loader
  })
  use({
    "nvim-telescope/telescope-media-files.nvim" -- Telescope extension to preview media files using Ueberzug.
  })
  use({
    "jvgrootveld/telescope-zoxide" -- An extension for telescope.nvim that allows you operate zoxide within Neovim.
  })

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter", -- Nvim Treesitter configurations and abstraction layer
    branch = "0.5-compat",
    run = ":TSUpdate",
    config = require("plugins.treesitter").config()
  })
  use({"nvim-treesitter/nvim-treesitter-refactor"}) -- Refactor module for nvim-treesitter
  use({"nvim-treesitter/nvim-treesitter-textobjects", branch = "0.5-compat"}) -- Create your own textobjects using tree-sitter queries!
  use({"romgrk/nvim-treesitter-context"}) -- Show code context
  use({"windwp/nvim-ts-autotag"}) -- Use treesitter to auto close and auto rename html tag
  use({"JoosepAlviste/nvim-ts-context-commentstring"}) -- Neovim treesitter plugin for setting the commentstring based on the cursor location in a file.
  use({"tpope/vim-commentary"}) -- commentary.vim: comment stuff out

  -- DAP
  -- https://github.com/mfussenegger/nvim-dap
  -- https://github.com/rcarriga/nvim-dap-ui
  use 'mfussenegger/nvim-dap'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'
  use {'nvim-telescope/telescope-dap.nvim'}
  use {'mfussenegger/nvim-dap-python'} -- Python
  use {'Pocco81/DAPInstall.nvim'}
  use {'jbyuki/one-small-step-for-vimkind'}

  -- Autocomplete, Snippets, Format
  -- Install nvim-cmp, and buffer source as a dependency
  use {
    "hrsh7th/nvim-cmp", -- Autocompletion plugin
    requires = {
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-buffer" -- nvim-cmp source for buffer words
    }
  }
  use("hrsh7th/cmp-path") -- nvim-cmp source for path
  use("hrsh7th/cmp-nvim-lua") -- nvim-cmp source for nvim lua
  use({
    "hrsh7th/cmp-nvim-lsp" -- LSP source for nvim-cmp
  })
  use({
    "saadparwaiz1/cmp_luasnip" -- Snippets source for nvim-cmp
  })
  use("L3MON4D3/LuaSnip") -- Snippets Plugin
  use 'sbdchd/neoformat' -- plugin for formatting code
  use 'christoomey/vim-system-copy' -- copy to system clipboard

  -- Coding
  --- nvim-go
  use {'crispgm/nvim-go'}
  -- vim-go
  use {
    'fatih/vim-go',
    run = ':GoUpdateBinaries',
    ft = {'go', 'gomod'}
    -- config = function()
    --   local g = vim.g
    --   g.go_gopls_enabled = 1
    --   g.go_fmt_autosave = 1
    --   g.go_fmt_command = [[gopls]]
    --   g.go_gopls_gofumpt = 1
    --   g.go_imports_mode = [[gopls]]
    --   g.go_fillstruct_mode = [[gopls]]
    --   g.go_rename_command = [[gopls]]
    --   g.go_metalinter_command = [[golangci-lint]]
    --   -- g.go_metalinter_enabled = {'vet', 'errcheck', 'staticcheck', 'gosimple'}
    --   -- g.go_metalinter_enabled = {'deadcode', 'errcheck', 'gosimple', 'govet', 'staticcheck', 'typecheck', 'unused', 'varcheck'}
    --   g.go_metalinter_autosave_enabled = {[[vet]], [[errcheck]], [[staticcheck]], [[gosimple]]}
    --   g.go_metalinter_autosave = 1
    --   g.go_test_show_name = 1
    --   g.go_imports_autosave = 1
    --   g.go_term_mode = [[split]]
    --   g.go_term_enabled = 1
    --   g.go_term_reuse = 1
    --   g.go_auto_type_info = 1

    --   g.go_highlight_fields = 0
    --   g.go_highlight_operators = 1
    --   g.go_highlight_functions = 1
    --   g.go_highlight_function_arguments = 1
    --   g.go_highlight_functions_calls = 1
    --   g.go_highlight_types = 1
    --   g.go_highlight_build_constraints = 1
    --   g.go_highlight_variable_declarations = 1

    --   g.go_gopls_staticcheck = 1
    --   g.go_diagnostics_level = 2
    --   g.go_gopls_matcher = [[fuzzy]]
    --   -- g.go_gopls_local = [[do]]

    --   g.go_code_completion_enabled = 0
    --   g.go_doc_keywordprg_enabled = 0
    --   g.go_def_mapping_enabled = 0
    --   g.go_echo_go_info = 0

    --   g.go_fold_enable = {}
    -- end
  }

  -- Debugging
  use {'puremourning/vimspector', requires = {{'mfussenegger/nvim-dap'}}, fn = "vimspector#Launch"}
  use {'nvim-telescope/telescope-vimspector.nvim'}
  use 'sebdah/vim-delve' -- Go debugger: delve.

  use({"jose-elias-alvarez/nvim-lsp-ts-utils"}) -- Utilities to improve the TypeScript development experience for Neovim's built-in LSP client.
  use 'ludovicchabant/vim-gutentags'
  use {"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"}
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install'}
  use 'numtostr/FTerm.nvim'
  use 'cespare/vim-toml' -- Vim syntax for TOML: https://github.com/cespare/vim-toml

  use 'tmhedberg/SimpylFold' -- Python folding: https://github.com/tmhedberg/SimpylFold

  use 'dart-lang/dart-vim-plugin' -- Flutter / Dart: https://github.com/dart-lang/dart-vim-plugin

  use 'hashivim/vim-terraform' -- Terraform: https://github.com/hashivim/vim-terraform

  -- Ruby
  use 'thoughtbot/vim-rspec' -- RSpec support for Vim
  use 'tpope/vim-rvm' -- RVM support for Vim

  -- Lua development
  use {'folke/lua-dev.nvim'}
  use {'simrat39/symbols-outline.nvim'}

  -- editing
  use 'andymass/vim-matchup'
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-surround'

  -- Comments
  use "terrortylor/nvim-comment"

  -- Git
  use({
    "lewis6991/gitsigns.nvim", -- Git signs written in pure lua
    requires = {"nvim-lua/plenary"},
    config = require("plugins.gitsigns").config()
  })
  use 'f-person/git-blame.nvim'
  use 'sindrets/diffview.nvim'
  use 'pwntester/octo.nvim'

  -- Productivity
  use 'jbyuki/nabla.nvim'
  use 'Pocco81/TrueZen.nvim'

  -- Utilities
  use 'nacro90/numb.nvim'
  use("folke/which-key.nvim") -- Create key bindings that stick. WhichKey is a lua plugin for Neovim 0.5 that displays a popup with possible keybindings of the command you started typing.
  use 'norcalli/nvim-colorizer.lua'
  use 'nvim-telescope/telescope-symbols.nvim'

  -- Syntax
  use 'MTDL9/vim-log-highlighting'

  -- Icons
  use 'kyazdani42/nvim-web-devicons' -- lua `fork` of vim-web-devicons for neovim
  use 'ryanoasis/vim-devicons'

  -- Explorer
  use({
    "kyazdani42/nvim-tree.lua", -- A file explorer tree for neovim written in lua
    config = require("plugins.nvimtree").config(),
    requires = "kyazdani42/nvim-web-devicons"
  })
  use 'airblade/vim-rooter'

  -- navigation
  use 'easymotion/vim-easymotion'

  -- Dashboard,
  -- use({
  --     "glepnir/dashboard-nvim", -- vim dashboard
  --     config = require("plugins.dashboard").config()
  -- })
  -- use {
  --     'glepnir/galaxyline.nvim',
  --     branch = 'main',
  --     config = function() require 'statusline' end,
  --     requires = {'kyazdani42/nvim-web-devicons', opt = true}
  -- }
  use 'rbgrouleff/bclose.vim'

  -- undo
  use 'mbbill/undotree'

  -- UI
  use({
    "lukas-reineke/indent-blankline.nvim", -- Indent guides for Neovim
    config = require("plugins.indent-blankline").config()
  })
  use({
    "akinsho/nvim-bufferline.lua", -- A snazzy bufferline for Neovim
    requires = "kyazdani42/nvim-web-devicons",
    config = require("plugins.bufferline").config()
  })
  use({
    "hoob3rt/lualine.nvim", -- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
    requires = {"kyazdani42/nvim-web-devicons", opt = true},
    config = require("plugins.lualine").config()
  })

  -- other
  use({
    "vuki656/package-info.nvim", -- See latest package versions in your package.json
    config = require("plugins.package-info").config()
  })

  use({
    "ahmedkhalf/project.nvim", -- The superior project management solution for neovim.
    config = require("plugins.project").config()
  })

  use({
    "jghauser/mkdir.nvim" -- This neovim plugin creates missing folders on save.
  })

  --  themes
  use({'shaunsingh/nord.nvim', config = require("plugins.nord").config()})

  -- Keep things up to date
  execute("PackerSync")

  -- --------------------------
  -- use 'sheerun/vim-polyglot'

  -- use 'lambdalisue/suda.vim'
  -- use 'jremmen/vim-ripgrep'
  -- use 'tpope/vim-fugitive'
  -- use 'leafgarland/typescript-vim'

  -- use 'honza/vim-snippets'
  -- use 'pangloss/vim-javascript'
  -- use 'jiangmiao/auto-pairs'
  -- use 'prettier/vim-prettier'
  -- use 'godlygeek/tabular'
  -- use 'turbio/bracey.vim'
  -- use 'mattn/emmet-vim'
  -- use 'junegunn/fzf.vim'
  -- use 'junegunn/fzf'

  -- use 'ap/vim-css-color'

  -- use 'peitalin/vim-jsx-typescript'
  -- use {'styled-components/vim-styled-components', branch = 'main'}
  -- use 'jparise/vim-graphql'
  -- use {'dracula/vim', as = 'dracula'}
  -- use 'ghifarit53/tokyonight-vim'
  -- use 'tomasiser/vim-code-dark'
  -- use 'dunstontc/vim-vscode-theme'
  -- use 'kevinhwang91/rnvimr'
  -- use 'akinsho/nvim-toggleterm.lua'
  -- use 'mfussenegger/nvim-jdtls'

  -- use 'andrejlevkovitch/vim-lua-format'
end

return M
