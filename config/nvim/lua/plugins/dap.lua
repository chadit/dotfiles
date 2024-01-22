-- dap.lua

-- Functional wrapper for mapping custom keybindings
-- mode (as in Vim modes like Normal/Insert mode)
-- lhs (the custom keybinds you need)
-- rhs (the commands or existing keybinds to customise)
-- opts (additional options like <silent>/<noremap>, see :h map-arguments for more info on it)
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


local M = {}

function M.new()
  return {
    { -- mfussenegger/nvim-dap
      "mfussenegger/nvim-dap",
      dependencies = {
        {
          "rcarriga/nvim-dap-ui",
          config = function()
            -- uses neodev to get type checking
            require("neodev").setup({
              library = { plugins = { "nvim-dap-ui" }, types = true },
            })
          end,
        },
        { "theHamsta/nvim-dap-virtual-text" },
        { "mfussenegger/nvim-dap-python" },      -- for python
        { "nvim-telescope/telescope-dap.nvim" }, -- for telescope integration
      },
      config = function()
        local path = require("mason-registry").get_package("debugpy"):get_install_path()
        require("dap-python").setup(path .. "/venv/bin/python")
      end,
    },
  }
end

function M.setup()
  local has_dap_plugin, dap = pcall(require, "dap")
  if not has_dap_plugin then
    return
  end

  local has_dapui_plugin, dapui = pcall(require, "dapui")
  if not has_dapui_plugin then
    return
  end

  require("nvim-dap-virtual-text").setup()

  dapui.setup({
    expand_lines = true,
    icons = { expanded = "", collapsed = "", circular = "" },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    layouts = {
      {
        elements = {
          { id = "scopes",      size = 0.33 },
          { id = "breakpoints", size = 0.17 },
          { id = "stacks",      size = 0.25 },
          { id = "watches",     size = 0.25 },
        },
        size = 0.33,
        position = "right",
      },
      {
        elements = {
          { id = "repl",    size = 0.45 },
          { id = "console", size = 0.55 },
        },
        size = 0.27,
        position = "bottom",
      },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      -- max_height = 0.9,
      -- max_width = 0.5,             -- Floats will be treated as percentage of your screen.
      border = "single", -- Border style. Can be 'single', 'double' or 'rounded'
      mappings = {
        close = { "q", "<Esc>" },
      },
      windows = { indent = 1 },
      render = { max_type_length = nil },
    },
  })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

function M.keymaps()
  map("n", "<F5>", '<cmd>lua require "dap".continue()<CR>', { silent = true, noremap = true })
  map("n", "<F10>", '<cmd>lua require "dap".step_over()<CR>', { silent = true, noremap = true })
  map("n", "<F11>", '<cmd>lua require "dap".step_into()<CR>', { silent = true, noremap = true })
  map("n", "<F12>", '<cmd>lua require "dap".step_out()<CR>', { silent = true, noremap = true })

  -- toggle a debug breakpoint
  map("n", "<leader>db", '<cmd>lua require "dap".toggle_breakpoint()<CR>', { silent = true, noremap = true })

  -- run the closes python run test
  vim.keymap.set(
    "n",
    "<leader>dpr",
    ":lua require('dap-python').test_method()<CR>",
    { silent = true, noremap = true }
  )

  -- run the python test class
  vim.keymap.set("n", "<leader>dpc", ":lua require('dap-python').test_class()<CR>", { silent = true, noremap = true })

  -- function() require('dap-python').debug_selection() end
  vim.keymap.set(
    "n",
    "<leader>dps <ESC>",
    ":lua require('dap-python').debug_selection()<CR>",
    { silent = true, noremap = true }
  )

  -- open dap gui
  vim.keymap.set("n", "<leader>dui", ":lua require('dapui').toggle()<CR>", { silent = true, noremap = true })

  vim.keymap.set("n", "<leader>du[", ":lua require('dapui').toggle(1)<CR>", { silent = true, noremap = true })

  vim.keymap.set("n", "<leader>du]", ":lua require('dapui').toggle(2)<CR>", { silent = true, noremap = true })
end

return M
