local opt = vim.opt
local cmd = vim.cmd
local data_dir = vim.fn.stdpath("data")
local M = {}
M.defaults = function()
    local has_keymaps, keymaps = pcall(require, "keymaps")
    if has_keymaps then keymaps.defaults() end
    cmd("filetype plugin on")
    opt.background = "dark"
    opt.backspace = "indent,eol,start"
    opt.backup = true
    opt.backupcopy = "auto"
    opt.backupdir = data_dir .. "/backups"
    opt.breakindent = true
    opt.clipboard = "unnamedplus"
    opt.completeopt = "menuone,noinsert,noselect"
    opt.cursorline = true
    opt.encoding = "UTF-8"
    opt.expandtab = true
    opt.foldlevelstart = 1
    opt.foldmethod = "syntax"
    opt.history = 10000
    opt.lazyredraw = true
    opt.mouse = "a"
    opt.number = true
    opt.relativenumber = true
    opt.scrolloff = 5
    opt.sessionoptions = "folds"
    opt.shiftwidth = 2
    opt.showmatch = true
    opt.signcolumn = "yes"
    opt.softtabstop = 2
    opt.splitbelow = true
    opt.tabstop = 2
    opt.termguicolors = true
    opt.title = true
    opt.undofile = true
    opt.undodir = data_dir .. "/undo"
    opt.updatetime = 100
    opt.viewoptions = "folds,cursor"
    opt.visualbell = true
    opt.wildmenu = true
    opt.writebackup = true
    local has_lsp, lsp = pcall(require, "settings.lsp")
    if has_lsp then lsp.load_config() end
    --  Return to the same position in the file when reopening
    cmd(
        [[autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif ]])
end
return M
