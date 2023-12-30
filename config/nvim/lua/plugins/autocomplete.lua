-- autocomplete.lua

local M = {}

function M.new()
  return {
    {
      -- Autocompletion framework
      "hrsh7th/nvim-cmp",
      event = {
        "InsertEnter",
        "CmdlineEnter",
      },
      dependencies = {
        -- LSP completion source
        "hrsh7th/cmp-nvim-lsp",
        -- Useful completion sources:
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",   -- source for text in buffer.
        "hrsh7th/cmp-path",     -- source for file system paths in commands.
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip", -- lua autocompletion.
        "L3MON4D3/LuaSnip",     -- snippet engine
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
        "rafamadriz/friendly-snippets", -- snippets library
        "onsails/lspkind.nvim",     -- vs-code like pictograms
      },
    },
  }
end

function M.setup()
  local has_plugin, cmp = pcall(require, "cmp")
  if not has_plugin then
    return
  end

  local kind_icons = {
    Text = "󰉿",
    Method = "m",
    Function = "󰊕",
    Constructor = "",
    Field = "",
    Variable = "󰆧",
    Class = "󰌗",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰇽",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰊄",
    Codeium = "󰚩",
    Copilot = "",
  }

  local luasnip = require("luasnip")

  -- load vscode style snippets from installed plugins.
  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup({
    completion = {
      completeopt = "menu,menuone,preview,noselect",
    },
    snippet = { -- configure how nvim-cmp interacts with snippet engine.
      expand = function(args)
        luasnip.lsp_expand(args.body)
        -- vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      -- Add tab support
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      ["<Tab>"] = cmp.mapping.select_next_item(),
      ["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }),
    },
    -- Installed sources:
    sources = {
      -- Copilot Source
      { name = "copilot",                group_index = 2 },
      -- Other Sources
      { name = "nvim_lsp",               keyword_length = 3, group_index = 2 }, -- from language server
      { name = "path",                   group_index = 2 },    -- file paths
      { name = "nvim_lsp_signature_help" },                    -- display function signatures with current parameter emphasized
      { name = "nvim_lua",               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
      { name = "buffer",                 keyword_length = 2 }, -- source current buffer
      { name = "vsnip",                  keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
      { name = "calc" },                                       -- source for math calculation
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    formatting = {
      fields = { "menu", "abbr", "kind" },
      format = function(entry, vim_item)
        vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
        local menu_icon = {
          nvim_lsp = "λ",
          vsnip = "⋗",
          buffer = "Ω",
          path = "🖫",
        }
        vim_item.menu = menu_icon[entry.source.name]
        return vim_item
      end,
    },
  })
end

return M
