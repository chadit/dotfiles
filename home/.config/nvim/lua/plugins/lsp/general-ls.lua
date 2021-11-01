local isort = {formatCommand = "isort --quiet -", formatStdin = true}
local clangf = {formatCommand = "clang-format", formatStdin = true}
local yapf = {formatCommand = "yapf --quiet", formatStdin = true}
local luaf = {formatCommand = "lua-format", formatStdin = true}
local latexindent = {formatCommand = "latexindent", formatStdin = true}
local cmakef = {formatCommand = 'cmake-format', formatStdin = true}
local shfmt = {formatCommand = 'shfmt -ci -s -bn', formatStdin = true}
local prettier = {formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true}
local shellcheck = {LintCommand = 'shellcheck -f gcc -x', lintFormats = {'%f:%l:%c: %trror: %m', '%f:%l:%c: %tarning: %m', '%f:%l:%c: %tote: %m'}}

-- require"lspconfig".efm.setup {
--   cmd = {"efm-langserver"},
--    init_options = {documentFormatting = true, codeAction = false},
--   filetypes = {"lua", "python", "cpp", "sh", "json", "yaml", "css", "html"},
--   settings = {rootMarkers = {".git/"}, languages = {python = {isort, yapf}, lua = {luaf}, tex = {latexindent}, sh = {shellcheck, shfmt}, cmake = {cmakef}, html = {prettier}, css = {prettier}, json = {prettier}, yaml = {prettier}, cpp = {clangf}}}
-- }
