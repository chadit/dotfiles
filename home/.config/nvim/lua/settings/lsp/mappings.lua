local lsp_mappings = {
	["<leader>"] = {
		c = {
			name = "LSP - Code",
			a = {
				"<cmd>lua require('lspsaga.codeaction').code_action()<CR>",
				"Code Action",
			},
		},
		d = {
			name = "LSP - Diagnostics",
			c = {
				"<cmd>lua require('lspsaga.diagnostic').show_cursor_diagnostics()<CR>",
				"Cursor Diagnostics",
			},
			l = {
				"<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>",
				"Line Diagnostics",
			},
		},
		e = { ":NvimTreeToggle<CR>", "Toggle Nvim-Tree" },
		f = {
			name = "Telescope",
			b = { "<cmd>Telescope buffers<cr>", "Buffers" },
			d = {
				":lua require('telescope').extensions.zoxide.list()<cr>",
				"Directories",
			},
			f = { "<cmd>Telescope find_files<cr>", "Find File" },
			g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
			h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
			m = {
				":lua require('telescope').extensions.media_files.media_files()<cr>",
				"Media files",
			},
		},
		r = { n = { "<cmd>lua require('lspsaga.rename').rename()<CR>", "Rename" } },
	},
	K = {
		"<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>",
		"Hover Docs",
	},
	["gd"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
	["gh"] = {
		"<cmd>lua require('lspsaga.provider').lsp_finder()<CR>",
		"References",
	},
	["gs"] = {
		"<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>",
		"Signature",
	},
	["[e"] = {
		"<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>",
		"Previous Diagnostics",
	},
	["]e"] = {
		"<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>",
		"Next Diagnostics",
	},
}

return lsp_mappings
