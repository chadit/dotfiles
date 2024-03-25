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
            formatting.shfmt.with { args = { "-i", "2" }, },                           -- (beautysh deprecated: use shfmt)                     -- bash
            formatting.black.with({ extra_args = { "--fast", "--line-length=120" } }), -- python
            formatting.buf,                                                            -- protobuf
            formatting.cmake_format,                                                   -- cmake
            formatting.gofumpt,                                                        -- golang
            formatting.goimports,                                                      -- golang
            formatting.goimports_reviser,                                              -- golang
            -- formatting.golines.with({                                                  -- golang, remove if you do not want it to auto wrap
            --   extra_args = {
            --     --"--max-len=180",
            --     "--base-formatter=gofumpt",
            --   },
            -- }),
            formatting.isort,        -- python
            formatting.markdownlint, -- markdown
            formatting.protolint,    -- protobuf
            formatting.stylua,       -- lua
            formatting.rubocop,      -- ruby
            formatting.yamlfmt,      -- yaml

            -- diagnostics.revive,              -- golang
            diagnostics.buf,
            diagnostics.gitlint,             -- git
            diagnostics.golangci_lint.with({ -- golang
              extra_args = {
                "-v",
                "--enable-all",
                "--disable=forbidigo",
                "--disable=gochecknoglobals"
              },
            }),

            diagnostics.markdownlint, -- markdown
            -- diagnostics.perlimports,  -- perl
            diagnostics.rubocop,      -- ruby
            diagnostics.selene,       -- lua
            diagnostics.staticcheck,  -- golang
            diagnostics.yamllint,     -- yaml
            diagnostics.zsh,          -- zsh

            completion.luasnip,
            completion.spell,

            -- used for go
            null_ls.builtins.code_actions.impl,

            -- require("go.null_ls").gotest(),
            -- require("go.null_ls").gotest_action(),
            -- require("go.null_ls").golangci_lint(),
          },
          debounce = 1000,
          default_timeout = 5000,
        })
      end,
    },
  }
end

return M
