local M = {}

M.config = function()
	local has_tokyonight = pcall(require, "tokyonight")
	if has_tokyonight then
		local g = vim.g

		g.tokyonight_style = "night"
		g.tokyonight_italic_functions = 1

		vim.cmd([[colorscheme tokyonight]])
	end
end

return M
