-- treesitter.lua

local M = {}

function M.new()
  return {
    -- Highlight, edit, and navigate code
    {
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
      },
      build = ':TSUpdate',
      event = {
        'BufReadPost *.go',
        'BufReadPost *.rs',
        'BufReadPost *.c',
        'BufReadPost *.gcc',
        'BufReadPost *.h',
        'BufReadPost *.ts',
        'BufReadPost *.js',
        'BufReadPost *.html',
        'BufReadPost *.css',
        'BufReadPost *.scss',
        'BufReadPost *.lua',
      },
    },
    { -- windwp/nvim-ts-autotag
      "windwp/nvim-ts-autotag",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require('nvim-ts-autotag').setup()
      end,
    },
  }
end

-- post install hook
function M.setup()
  local has_plugin, plg = pcall(require, "nvim-treesitter.configs")
  if not has_plugin then return end

  ---@diagnostic disable-next-line: missing-fields
  plg.setup({
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = {
      "bash",
      "c",
      -- "c_sharp",
      "cmake",
      "cpp",
      "css",
      "csv",
      "dart",
      "dockerfile",
      "elixir",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "go",
      "gomod",
      "gosum",
      "haskell",
      "hcl",
      "html",
      "javascript",
      "jq",
      "json",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "perl",
      "python",
      "regex",
      "ruby",
      "rust",
      "ssh_config",
      "terraform",
      --"tmux",
      "toml",
      "typescript",
      "vim",
      "vimdoc",
      "query",
      "yaml",
      "zig",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    autotag = {
      enable = true,
      enable_rename = true,
      enable_close = true,
      enable_close_on_slash = true,
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil,
    }
  })
end

return M
