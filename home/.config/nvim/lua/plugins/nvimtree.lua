local M = {}

M.config = function()

  require('nvim-tree').setup {
    -- disables netrw completely
    disable_netrw = true,
    -- hijack netrw window on startup
    hijack_netrw = true,
    -- open the tree when running this setup function
    open_on_setup = true,
    -- closes neovim automatically when the tree is the last **WINDOW** in the view
    auto_close = false,
    -- hijack the cursor in the tree to put it at the start of the filename
    hijack_cursor = true,
    -- show lsp diagnostics in the signcolumn
    lsp_diagnostics = true
  }

  local g = vim.g
  g.loaded_netrw = 1
  g.loaded_netrwPlugin = 1

  g.nvim_tree_width = 35
  g.nvim_tree_auto_open = 1
  g.nvim_tree_auto_close = 1 -- was 0
  g.nvim_tree_quit_on_open = 0
  g.nvim_tree_side = "left"
  g.nvim_tree_follow = 1
  g.nvim_tree_indent_markers = 1
  g.nvim_tree_hide_dot_files = 1
  g.nvim_tree_git_hl = 1
  g.nvim_tree_root_folder_modifier = ":t"
  g.nvim_tree_tab_open = 1
  g.nvim_tree_allow_resize = 1
  g.nvim_tree_lsp_diagnostics = 1
  g.nvim_tree_special_files = {'README.md', 'Makefile', 'MAKEFILE'}
  g.nvim_tree_auto_ignore_ft = {"startify", "dashboard"}
  g['nvim_tree_ignore'] = {'.git', 'node_modules', '.cache', '__pycache__', '.meta', '.csproj', '.sln', '.vscode', '.vs'}
  g.nvim_tree_show_icons = {git = 1, folders = 1, files = 1, folder_arrows = 1}
  g.nvim_tree_icons = {default = "", symlink = "", git = {unstaged = "", staged = "S", unmerged = "", renamed = "➜", deleted = "", untracked = "U", ignored = "◌"}, folder = {default = "", open = "", empty = "", empty_open = "", symlink = ""}}
end

M.keymaps = {["<leader>e"] = {":NvimTreeToggle<CR>", "NvimTree Toggle"}}

return M
