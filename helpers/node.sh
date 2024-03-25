#!/bin/zsh

function node_update_nvm() {
  # Fetch the current version of nvm
  current_version=$(nvm --version)
  echo "Current version of nvm: $current_version"

  # Fetch the latest version of nvm
  latest_version=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep 'tag_name' | cut -d\" -f4 | sed 's/v//')
  echo "Latest version of nvm: $latest_version"

  # Compare versions and update if the latest version is newer
  if [ "$current_version" != "$latest_version" ]; then
    echo "Updating nvm to the latest version: $latest_version"
    # using githubusercontent to always get the latest from master
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  else
    echo "nvm is already at the latest version."
  fi
}

function node_install_locations() {
  npm install -g nodist
}

function node_update_npm_latest() {
  npm install -g npm@latest
}

function node_dependencies() {
  npm install -g vscode-css-languageserver-bin
  npm install -g dockerfile-language-server-nodejs
  npm install -g graphql-language-service-cli
  npm install -g vscode-html-languageserver-bin
  npm install -g typescript typescript-language-server
  npm install -g vscode-json-languageserver
  npm install -g yaml-language-server
  npm install -g bash-language-server

  npm install -g aws-cdk

  # npm init @eslint/config
}

function node_update() {
  node_update_nvm

  # ensure nvm is using the latest node.
  nvm install node

  node_update_npm_latest
  node_dependencies

  # clears the npm cache.
  sudo npm cache clean -f

  # not sure this is needed
  # sudo n latest
}

function node_setup() {
  if test -d "$HOME/.nvm"; then
    export NVM_DIR=$HOME/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    echo "nvm $(nvm --version)"
  else
    echo "nvm not found, running install, restart shell when complete"
    node_update
  fi

  if test -d "$HOME/.yarn/bin"; then
    # added bin for yarn npm applications
    pathmunge $HOME/.yarn/bin
  fi

  if test -d "$HOME/.npm-global/bin"; then
    pathmunge $HOME/.npm-global/bin
  fi

  if command -v node >/dev/null 2>&1; then
    echo "Node: $(node --version 2>&1 | head -n 1)"
  else
    echo "Node not found, please install"
  fi
}
