local M = {}

M.config = function()
    vim.g.dashboard_default_executive = "telescope"

    local doom = {}

    vim.g.dashboard_custom_header = doom

    vim.g.dashboard_custom_section = {
        a = {
            description = {"  Find File          "},
            command = "Telescope find_files"
        },
        b = {
            description = {"  Recent Projects    "},
            command = "Telescope projects"
        },
        c = {
            description = {"  Recently Used Files"},
            command = "Telescope oldfiles"
        }
    }

    local plugin_dir = string.format("%s/site/pack/packer/start/",
                                     vim.fn.stdpath("data"))
    local total_plugins = vim.fn.len(vim.fn.globpath(plugin_dir, "*", 0, 1))
    vim.g.dashboard_custom_footer = {
        "Loaded " .. total_plugins .. " plugins  "
    }
end

return M