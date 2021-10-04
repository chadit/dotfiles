local M = {}

M.config = function()
    local has_treesitter, treesitter = pcall(require, "nvim-treesitter.configs")
    if not has_treesitter then return end

    treesitter.setup({
        autotag = {
            enable = true,
            filetypes = {
                "html", "javascript", "javascriptreact", "typescriptreact",
                "svelte", "vue", "astro", "markdown"
            }
        },

        context_commentstring = {enable = true},

        -- ensure_installed = "maintained", -- one of 'all', 'language', or a list of languages
        ensure_installed = {
            "query", "bash", "html", "cpp", "c", "go", "gomod", "ruby",
            "svelte", "graphql", "java", "json", "php", "python", "rust",
            "typescript", "vue", "yaml", "regex", "javascript", "scss", "css",
            "lua", "toml", "dockerfile"
        },

        highlight = {
            enable = true -- false will disable the whole extension
        },

        incremental_selection = {
            enable = true,
            keymaps = { -- mappings for incremental selection (visual mappings)
                init_selection = "gnn", -- maps in normal mode to init the node/scope selection
                node_incremental = "grn", -- increment to the upper named parent
                scope_incremental = "gns", -- increment to the upper scope (as defined in locals.scm)
                node_decremental = "grm" -- decrement to the previous node
            }
        },

        indent = {enable = true},

        refactor = {
            highlight_definitions = {enable = true},
            highlight_current_scope = {enable = true},
            smart_rename = {enable = true, keymaps = {smart_rename = "grr"}},
            navigation = {
                enable = true,
                keymaps = {
                    goto_definition = "gnd",
                    list_definitions = "gnD",
                    list_definitions_toc = "gO",
                    goto_next_usage = "<a-*>",
                    goto_previous_usage = "<a-#>"
                }
            }
        },

        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner"
                }
            },
            swap = {
                enable = true,
                swap_next = {["<leader>a"] = "@parameter.inner"},
                swap_previous = {["<leader>A"] = "@parameter.inner"}
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer"
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer"
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer"
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer"
                }
            },
            lsp_interop = {
                enable = true,
                peek_definition_code = {
                    ["df"] = "@function.outer",
                    ["dF"] = "@class.outer"
                }
            }
        }
    })
end

return M
