local M = {}

M.config = function()
	local has_trouble, trouble = pcall(require, "trouble")
	if has_trouble then
		trouble.setup({
			indent_lines = true, -- add an indent guide below the fold icons
			auto_open = false, -- automatically open the list when you have diagnostics
			auto_close = true, -- automatically close the list when you have no diagnostics
			auto_preview = true, -- automatyically preview the location of the diagnostic. <esc> to close preview and go back to last window
			auto_fold = false, -- automatically fold a file trouble list at creation
			use_lsp_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
		})
	end
end

M.keymaps = {
	["<leader>"] = {
		x = {
			name = "Trouble",
			x = { "<cmd>TroubleToggle<cr>", "Toggle" },
			w = {
				"<cmd>TroubleToggle lsp_workspace_diagnostics<cr>",
				"Workspace Diagnostics",
			},
			d = {
				"<cmd>TroubleToggle lsp_document_diagnostics<cr>",
				"Document Diagnostics",
			},
			q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
		},
	},
}
return M
