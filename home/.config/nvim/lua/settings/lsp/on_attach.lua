local on_attach = function(client, bufnr)
	if client.resolved_capabilities.document_formatting then
		vim.cmd([[autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]])
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	if client.name == "typescript" then
		local has_ts_utils, ts_utils = pcall(require, "nvim-lsp-ts-utils")
		if has_ts_utils then
			ts_utils.setup({
				enable_import_on_completion = true,
			})
			ts_utils.setup_client(client)
		end
		client.resolved_capabilities.document_formatting = false
		client.resolved_capabilities.document_range_formatting = false
	end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
	local has_signature, signature = pcall(require, "lsp_signature")
	if has_signature then
		signature.on_attach({
			bind = true, -- This is mandatory, otherwise border config won't get registered.
			-- If you want to hook lspsaga or other signature handler, pls set to false
			doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
			-- set to 0 if you DO NOT want any API comments be shown
			-- This setting only take effect in insert mode, it does not affect signature help in normal
			-- mode, 10 by default

			floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
			fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
			hint_enable = true, -- virtual hint enable
			hint_prefix = "🐼 ", -- Panda for parameter
			hint_scheme = "String",
			use_lspsaga = true, -- set to true if you want to use lspsaga popup
			hi_parameter = "Search", -- how your parameter will be highlight
			max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
			-- to view the hiding contents
			max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
			handler_opts = {
				border = "shadow", -- double, single, shadow, none
			},
			extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
			-- deprecate !!
			-- decorator = {"`", "`"}  -- this is no longer needed as nvim give me a handler and it allow me to highlight active parameter in floating_window
			zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
			debug = false, -- set to true to enable debug logging
			log_path = "debug_log_file_path", -- debug log path

			padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc

			shadow_blend = 36, -- if you using shadow as border use this set the opacity
			shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
		}, bufnr)
	end
end

return on_attach
