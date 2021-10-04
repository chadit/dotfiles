local common = require('plugins.lsp.common')

-- GO111MODULE=on go get golang.org/x/tools/gopls@latest
require'lspconfig'.gopls.setup {
    cmd = {"gopls", "-remote=auto"},
    dap_debug = true,
    on_attach = common.on_attach,
    capabilities = common.compeSnippetCapabilities(),
    init_options = {
        gofumpt = true,
        usePlaceholders = true,
        matcher = "Fuzzy",
        codelenses = {generate = true, test = true},
        analyses = {
            fieldalignment = true,
            nilness = true,
            shadow = true,
            unreachable = true,
            unusedparams = true,
            unusedwrites = true
        },
        staticcheck = true
    }
}
