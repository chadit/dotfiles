local fn = vim.fn
local cmd = vim.cmd
local executable = function(x) return fn.executable(x) == 1 end

local lsServers = {
  [[ansible-language-server]],
  [[bash-language-server]],
  [[typescript-language-server]],
  [[vscode-html-languageserver-bin]],
  [[pyright]],
  [[vim-language-server]],
  [[cmake-language-server]],
  [[diagnostic-languageserver]],
  [[dockerfile-language-server-nodejs]],
  [[yaml-language-server]]
}

for _, lsp in ipairs(lsServers) do
  local name = lsp
  if lsp == [[vscode-html-languageserver-bin]] then
    name = [[html-languageserver]]
  elseif lsp == [[dockerfile-language-server-nodejs]] then
    name = [[docker-langserver]]
  end

  local ispip = false
  if lsp == [[cmake-language-server]] then ispip = true end
  local isyarn = false
  if lsp == [[diagnostic-languageserver]] or lsp == [[yaml-language-server]] then isyarn = true end
  local isAnsible = false
  if lsp == [[ansible-language-server]] then isAnsible = true end

  if not executable(name) then
    if ispip == false and isyarn == false and isAnsible == false then
      cmd(string.format([[:!npm install -g %s]], lsp))
    elseif ispip == true then
      cmd(string.format([[:!pip3 install %s]], lsp))
    elseif isyarn == true then
      cmd(string.format([[:!yarn global add %s]], lsp))
    elseif isAnsible == true then
      -- ansible requires extra steps
      cmd([[:!pip3 install "ansible-lint[community,yamllint]"]])
      cmd([[:!yarn global add ansible-language-server]])
      cmd([[:!yarn add yaml-language-server]])
    end
  end
end

require("plugins.lsp.sumneko")
require("plugins.lsp.tsserver")
require("plugins.lsp.go")
require("plugins.lsp.gopls")
require("plugins.lsp.bashls")
