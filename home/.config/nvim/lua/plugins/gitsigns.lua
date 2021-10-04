local M = {}

M.config = function()
    local has_gitsigns, gitsigns = pcall(require, "gitsigns")
    if not has_gitsigns then return end
    gitsigns.setup({
        signs = {
            add = {
                hl = "GitSignsAdd",
                text = "█",
                numhl = "GitSignsAddNr",
                linehl = "GitSignsAddLn"
            },
            change = {
                hl = "GitSignsChange",
                text = "█",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn"
            },
            delete = {
                hl = "GitSignsDelete",
                text = "_",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn"
            },
            topdelete = {
                hl = "GitSignsDelete",
                text = "‾",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn"
            },
            changedelete = {
                hl = "GitSignsChange",
                text = "~",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn"
            }
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        diff_opts = {
            internal = true -- If vim.diff or luajit is present
        },
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        keymaps = {
            -- Default keymap options
            noremap = true,

            ["n ]c"] = {
                expr = true,
                "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"
            },
            ["n [c"] = {
                expr = true,
                "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"
            },

            ["v <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
            ["v <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',

            -- Text objects
            ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
            ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
        },
        watch_gitdir  = {interval = 1000, follow_files = true},
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
            delay = 1000
        },
        current_line_blame_formatter_opts = {relative_time = false},
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000,
        preview_config = {
            -- Options passed to nvim_open_win
            border = "single",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1
        },
        yadm = {enable = false}
    })
end

M.keymaps = {
    ["<leader>h"] = {
        name = "GitSigns",
        s = {'<cmd>lua require"gitsigns".stage_hunk()<CR>', "Stage hunk"},
        u = {
            '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
            "Undo stage hunk"
        },
        r = {'<cmd>lua require"gitsigns".reset_hunk()<CR>', "Reset hunk"},
        R = {'<cmd>lua require"gitsigns".reset_buffer()<CR>', "Reset Buffer"},
        p = {'<cmd>lua require"gitsigns".preview_hunk()<CR>', "Preview hunk"},
        b = {'<cmd>lua require"gitsigns".blame_line(true)<CR>', "Blame (line)"},
        S = {'<cmd>lua require"gitsigns".stage_buffer()<CR>', "Stage buffer"},
        U = {
            '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',
            "Reset buffer index"
        }
    }
}

return M
