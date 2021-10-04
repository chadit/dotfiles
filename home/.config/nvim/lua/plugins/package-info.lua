local M = {}

M.config = function()
    local has_package_info, pkg = pcall(require, "package-info")
    if not has_package_info then return end

    pkg.setup()
end

M.keymaps = {
    ["<leader>p"] = {
        s = {"<cmd>lua require('package-info').show()<cr>", "Show Package Info"},
        h = {"<cmd>lua require('package-info').hide()<cr>", "Hide Package Info"}
    }
}

return M
