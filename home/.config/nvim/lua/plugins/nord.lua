local M = {}

M.config = function()
    local hasModule = pcall(require, "nord")
    if hasModule then
        local g = vim.g

        g.nord_contrast = true
        g.nord_borders = true
        g.nord_disable_background = false
        g.nord_italic = false

        vim.cmd([[colorscheme nord]])
    end
end

return M
