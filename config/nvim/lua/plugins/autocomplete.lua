-- autocomplete.lua

-- local show = vim.schedule_wrap(function(msg)
--   local has_notify, notify = pcall(require, "plugins.notify")
--   if has_notify then
--     notify.notify_info(msg, "ensure-tools")
--   end
-- end)

local M = {}

function M.new()
  return {
    {
      -- Autocompletion framework
      { 'hrsh7th/nvim-cmp' },

      -- LSP completion source
      { 'hrsh7th/cmp-nvim-lsp' },

      -- Useful completion sources:
      { 'hrsh7th/cmp-nvim-lua' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'hrsh7th/cmp-vsnip' },
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/vim-vsnip' },

      -- Snippet Engine & its associated nvim-cmp source
      { 'L3MON4D3/LuaSnip' },
      { 'saadparwaiz1/cmp_luasnip' },

      -- Adds a number of user-friendly snippets
      { 'rafamadriz/friendly-snippets' },
    },
  }
end

function M.setup()
  local has_plugin, cmp = pcall(require, "cmp")
  if not has_plugin then return end

  cmp.setup({
    -- Enable LSP snippets
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      -- Add tab support
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      })
    },
    -- Installed sources:
    sources = {
      { name = 'path' },                                       -- file paths
      { name = 'nvim_lsp',               keyword_length = 3 }, -- from language server
      { name = 'nvim_lsp_signature_help' },                    -- display function signatures with current parameter emphasized
      { name = 'nvim_lua',               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
      { name = 'buffer',                 keyword_length = 2 }, -- source current buffer
      { name = 'vsnip',                  keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
      { name = 'calc' },                                       -- source for math calculation
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    formatting = {
      fields = { 'menu', 'abbr', 'kind' },
      format = function(entry, item)
        local menu_icon = {
          nvim_lsp = 'λ',
          vsnip = '⋗',
          buffer = 'Ω',
          path = '🖫',
        }
        item.menu = menu_icon[entry.source.name]
        return item
      end,
    },
  })
end

return M
