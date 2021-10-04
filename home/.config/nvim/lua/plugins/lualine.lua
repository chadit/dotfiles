local M = {}

-- Color table for highlights
local colors = {
    bg = '#202328',
    fg = '#bbc2cf',
    yellow = '#ECBE7B',
    cyan = '#008080',
    darkblue = '#081633',
    green = '#98be65',
    orange = '#FF8800',
    violet = '#a9a1e1',
    magenta = '#c678dd',
    blue = '#51afef',
    red = '#ec5f67'
}

local components = {
    treesitter = {
        function() return "  " end,
        condition = function()
            if next(vim.treesitter.highlighter.active) then
                return true
            end

            return false
        end,
        color = {fg = "green"}
    },
    diagnostics = {
        "diagnostics",
        sources = {"nvim_lsp"},
        symbols = {error = " ", warn = " ", info = " ", hint = " "},
        color_error = colors.red,
        color_warn = colors.yellow,
        color_info = colors.cyan
    }
}

M.config = function()
    local has_lualine, lualine = pcall(require, "lualine")
    if not has_lualine then return end

    lualine.setup({
        options = {
            -- theme = "tokyonight",
            theme = "nord",
            -- section_separators = {'', ''},
            -- component_separators = {'', ''},
            -- component_separators = {"", ""},
            -- section_separators = {"", ""},
            icons_enabled = true
        },
        disabled_filetypes = {"dashboard"},
        extensions = {"nvim-tree"},
        -- sections = {
        --     lualine_c = {"filename", components.diagnostics},
        --     lualine_x = {"encoding", "fileformat", components.treesitter},
        --     lualine_y = {"filetype"}
        -- }
        sections = {
            lualine_a = {{'mode', upper = true}},
            -- lualine_b = {{'branch', icon = ''}},
            lualine_b = {{'branch', icon = '', icon_only = true}},
            lualine_c = {{'filename', file_status = true}},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {{'diagnostics', sources = {'nvim_lsp'}}, 'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename', 'file_status'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        }
    })
end

return M
