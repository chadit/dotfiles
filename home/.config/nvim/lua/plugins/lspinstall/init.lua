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
  [[yaml-language-server]],
  [[efm-langserver]]
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
  local isGoInstallemf = false
  if lsp == [[efm-langserver]] then isGoInstallemf = true end

  if not executable(name) then
    if ispip == false and isyarn == false and isAnsible == false and isGoInstallemf == false then
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
    elseif isGoInstallemf == true then
    --  cmd([[:!go install github.com/mattn/efm-langserver@latest]])
    end
  end
end

require("plugins.lsp.bash-ls")
require("plugins.lsp.css-ls")
require("plugins.lsp.docker-ls")
require("plugins.lsp.general-ls")
require("plugins.lsp.go")
require("plugins.lsp.gopls")
require("plugins.lsp.graphql-ls")
require("plugins.lsp.html-ls")
require("plugins.lsp.javascript-ls")
require("plugins.lsp.json-ls")
require("plugins.lsp.lua-ls")
-- require("plugins.lsp.python-ls")
 require("plugins.lsp.sumneko")
require("plugins.lsp.tsserver")
require("plugins.lsp.yaml-ls")
