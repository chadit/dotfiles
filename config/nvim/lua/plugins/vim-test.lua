local M = { ignore = false }

local function DebugNearest()
  -- Temporarily set the Go test runner to 'delve'
  vim.g['test#go#runner'] = 'delve'

  -- Execute the TestNearest command. This is done by calling Vim command from Lua
  vim.cmd('TestNearest')

  -- Remove the override after the test is executed
  vim.g['test#go#runner'] = nil
end

function M.new()
  return {
    {
      "vim-test/vim-test",
      dependencies = {
        "preservim/vimux",                     -- for running tests in a tmux pane
        { "sebdah/vim-delve", ft = { "go" } }, -- for debugging go tests
      },
      vim.keymap.set("n", "<leader>t", ":TestNearest<CR>"),
      vim.keymap.set("n", "<leader>dt", ":DebugNearest<CR>"),
      vim.keymap.set("n", "<leader>T", ":TestFile<CR>"),
      vim.keymap.set("n", "<leader>l", ":TestLast<CR>"),
      vim.keymap.set("n", "<leader>a", ":TestSuite<CR>"),
      vim.keymap.set("n", "<leader>g", ":TestVisit<CR>"),

      vim.cmd("let test#strategy = 'vimux'"),
      vim.api.nvim_set_var("test#go#gotest#options", "-v -count=1 -race -timeout=30s"),
      vim.api.nvim_create_user_command('DebugNearest', DebugNearest, {}),
    },
  }
end

return M
