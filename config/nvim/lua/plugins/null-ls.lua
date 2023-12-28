-- null-ls.lua

local M = {}

function M.new()
  return {
    {
      "nvimtools/none-ls.nvim",
      --event = "BufReadPre",
      dependencies = "nvim-lua/plenary.nvim",
      config = function()
        local null_ls = require("null-ls")
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
        local formatting = null_ls.builtins.formatting
        -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
        local diagnostics = null_ls.builtins.diagnostics

        local completion = null_ls.builtins.completion
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
            formatting.black.with({ extra_args = { "--fast", "--line-length=120" } }), -- python
            formatting.isort,                                                    -- python
            formatting.stylua,                                                   -- lua
            formatting.gofmt,                                                    -- golang
            formatting.goimports,                                                -- golang
            formatting.markdownlint,                                             -- markdown
            formatting.rubocop,                                                  -- ruby

            diagnostics.golangci_lint,                                           -- golang
            diagnostics.markdownlint,                                            -- markdown
            diagnostics.eslint_d,                                                -- javascript
            diagnostics.rubocop,                                                 -- ruby

            completion.spell,
          },
        })
      end,
    },
  }
end

return M
