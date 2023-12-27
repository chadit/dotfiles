-- neotest.lua

local show = vim.schedule_wrap(function(msg)
  local has_notify, notify = pcall(require, "plugins.notify")
  if has_notify then
    notify.notify_info(msg, "ensure-tools")
  end
end)

local function config()
  local status_ok, nt = pcall(require, "neotest")
  if not status_ok then
    return
  end

  local namespace = vim.api.nvim_create_namespace "neotest"
  vim.diagnostic.config({
    virtual_text = {
      format = function(diagnostic)
        return diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
      end,
    },
  }, namespace)

  local opts = {
    running = {
      concurrent = false,
    },
    status = {
      virtual_text = true,
      signs = false,
    },
    strategies = {
      integrated = {
        width = 180,
      },
    },
    discovery = {
      enabled = true,
    },
    diagnostic = {
      enabled = true,
    },
    icons = {
      running = "󰥔 ",
    },
    floating = {
      border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
    },
    adapters = {
      require "neotest-rust",
      require "neotest-go" {
        experimental = {
          test_table = true,
        },
      },
      require "neotest-python" {
        dap = { justMyCode = false, console = "integratedTerminal" },
        args = { "--log-level", "DEBUG", "-- quiet" },
        -- runner = "unittest",
      },
      require "neotest-plenary",
    },
  }

  show("neotest setup")
  nt.setup(opts)
end


local M = {}

function M.new()
  return {
    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-neotest/neotest-plenary",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-vim-test", -- for neotest vim test runners
      },
      config = function()
        config()
      end,
      --event = { "BufReadPost", "BufNew" },
    },
    { "nvim-neotest/neotest-go",     event = { "BufEnter *.go" }, ft = "go" },
    { "nvim-neotest/neotest-python", event = { "BufEnter *.py" }, ft = "python" },
    -- { "rouge8/neotest-ruby",         event = { "BufEnter *.rb" }, ft = "ruby" },
    { "rouge8/neotest-rust",         event = { "BufEnter *.rs" }, ft = "rust" },
  }
end

M.get_env = function()
  local env = {}
  for _, file in ipairs { ".env" } do
    if vim.fn.empty(vim.fn.glob(file)) ~= 0 then
      break
    end

    for _, line in ipairs(vim.fn.readfile(file)) do
      for name, value in string.gmatch(line, "(.+)=['\"]?(.*)['\"]?") do
        local str_end = string.sub(value, -1, -1)
        if str_end == "'" or str_end == '"' then
          value = string.sub(value, 1, -2)
        end

        env[name] = value
      end
    end
  end
  return env
end

function M.run_all()
  local neotest = require "neotest"
  show("newtest run all " .. tostring(neotest.state.adapter_ids()))
  -- for _, adapter_id in ipairs(neotest.run.adapters()) do
  for _, adapter_id in ipairs(neotest.state.adapter_ids()) do
    show("newtest adapter id :" .. tostring(adapter_id))
    neotest.run.run { suite = true, adapter = adapter_id }
  end
end

function M.cancel()
  require("neotest").run.stop { interactive = true }
end

function M.run_file_sync()
  require("neotest").run.run { vim.fn.expand "%", concurrent = false }
end

function M.keymaps()
  -- run the nearest test
  vim.keymap.set('n', '<leader>nda', ":lua require('plugins.neotest').run_all()<CR>",
    { silent = true, noremap = true })

  -- run the nearest test
  vim.keymap.set('n', '<leader>nn', ":lua require('neotest').run.run()<CR>",
    { silent = true, noremap = true })

  -- Debug the nearest test (requires nvim-dap and adapter support)
  vim.keymap.set('n', '<leader>ndn', ":lua require('neotest').run.run({strategy = 'dap'})<CR>",
    { silent = true, noremap = true })

  vim.keymap.set('n', '<leader>ndf', ":lua require('neotest').run.run({vim.fn.expand('%')})<CR>",
    { silent = true, noremap = true })
end

return M
