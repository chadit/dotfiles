-- autocomplete.lua

local M = {}

function M.new()
  return {
    {
      "hrsh7th/cmp-nvim-lsp", -- LSP completion source
    },
    {
      "L3MON4D3/LuaSnip",               -- snippet engine
      dependencies = {
        "saadparwaiz1/cmp_luasnip",     -- lua autocompletion.
        "rafamadriz/friendly-snippets", -- snippets library (vscode style)
      }
    },
    {
      -- Autocompletion framework
      "hrsh7th/nvim-cmp",
      event = {
        "InsertEnter",
        "CmdlineEnter",
      },
      dependencies = {

        -- Useful completion sources:
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer", -- source for text in buffer.
        "hrsh7th/cmp-path",   -- source for file system paths in commands.
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip",
        "onsails/lspkind.nvim", -- vs-code like pictograms
      },
    },
  }
end

function M.setup()
  local has_plugin, cmp = pcall(require, "cmp")
  if not has_plugin then
    return
  end

  local snip_status_ok, luasnip = pcall(require, "luasnip")
  if not snip_status_ok then
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

  -- load vscode style snippets from installed plugins.
  require("luasnip.loaders.from_vscode").lazy_load()

  -- `/` cmdline setup.
  -- cmp.setup.cmdline('/', {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = {
  --     { name = 'buffer' }
  --   }
  -- })

  -- `:` cmdline setup.
  -- cmp.setup.cmdline(':', {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = cmp.config.sources({
  --     { name = 'path' }
  --   }, {
  --     {
  --       name = 'cmdline',
  --       option = {
  --         ignore_cmds = { 'Man', '!' }
  --       }
  --     }
  --   })
  -- })


  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      return false
    end
    ---@diagnostic disable-next-line: deprecated
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
  end

  local check_backspace = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
  end


  cmp.setup({
    completion = {
      completeopt = "menu,menuone,preview,noselect",
    },
    snippet = { -- configure how nvim-cmp interacts with snippet engine.
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
        -- vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      -- ["<Tab>"] = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     cmp.select_next_item()
      --   else
      --     fallback()
      --   end
      -- end, { "c" }),
      -- ['<tab>'] = {
      --   i = ...,
      --   c = cmp.config.disable
      -- },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif cmp.visible() and has_words_before() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
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
      { name = "path",                   group_index = 2 },                     -- file paths
      { name = "nvim_lsp_signature_help" },                                     -- display function signatures with current parameter emphasized
      { name = "nvim_lua",               keyword_length = 2 },                  -- complete neovim's Lua runtime API such vim.lsp.*
      { name = "buffer",                 keyword_length = 2 },                  -- source current buffer
      { name = "vsnip",                  keyword_length = 2 },                  -- nvim-cmp source for vim-vsnip
      { name = "calc" },                                                        -- source for math calculation
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
