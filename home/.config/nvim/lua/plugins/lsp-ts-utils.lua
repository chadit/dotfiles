local M = {}

M.keymaps = {
	["<leader>c"] = {
		o = { ":TSLspOrganize<CR>", "Organize TS imports" },
		i = { ":TSLspImportAll", "Import all TS dependencies" },
	},
}

return M
