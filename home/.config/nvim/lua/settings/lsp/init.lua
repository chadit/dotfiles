local has_lspconfig, nvim_lsp = pcall(require, "lspconfig")
local on_attach = require("settings.lsp.on_attach")
local capabilities = require("settings.lsp.capabilities")
local config = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {debounce_text_changes = 150}
}

local servers = {lua = require("lua-dev").setup(config)}

local M = {}

local function setup_servers()
    require("lspinstall").setup()
    local installed = require("lspinstall").installed_servers()
    for _, server in pairs(installed) do
        local server_config = servers[server] or config
        nvim_lsp[server].setup(server_config)
    end

    local has_null, null = pcall(require, "null-ls")
    if has_null then
        local null_config = {
            sources = {
                -- diagnostics
                null.builtins.diagnostics.eslint_d,
                null.builtins.diagnostics.selene, -- A blazing-fast modern Lua linter written in Rust
                -- formatting
                null.builtins.formatting.stylua,
                null.builtins.formatting.eslint_d,
                null.builtins.formatting.terraform_fmt
            }
        }
        null.config(null_config)
        nvim_lsp["null-ls"].setup(config)
    end
end

local function setup_completion()
    local luasnip = require("luasnip")
    local cmp = require("cmp")
    local has_lspkind, lspkind = pcall(require, "lspkind")
    cmp.setup({
        formatting = {
            format = function(_, vim_item)
                if has_lspkind then
                    vim_item.kind = lspkind.presets.default[vim_item.kind]
                end
                return vim_item
            end
        },
        snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
        mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm(
                {behavior = cmp.ConfirmBehavior.Replace, select = true})
        },
        sources = {
            {name = "nvim_lsp"}, {name = "path"}, {name = "buffer"},
            {name = "nvim_lua"}, {name = "luasnip"}
        }
    })

    require("cmp_nvim_lsp").setup()
end

M.load_config = function()
    if not has_lspconfig then return end
    local saga = require("lspsaga")
    saga.init_lsp_saga()

    setup_servers()
    setup_completion()
    require("lspinstall").post_install_hook =
        function()
            setup_servers() -- reload installed servers
            vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
        end
end

return M
