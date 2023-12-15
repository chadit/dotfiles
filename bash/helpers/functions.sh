#!/bin/bash

# reset_terminal will clear the screens and rest the terminal
reset_terminal1() {
  tmux clear-history
  reset
  clear
}

# pathmunge adds items to the path, verifies if it exist on the path first.
# pathmunge /sbin/             ## Add to the start; default
# pathmunge /usr/sbin/ after   ## Add to the end
pathmunge() {
  if ! echo "$PATH" | grep -Eq "(^|:)$1($|:)"; then
    if [ "$2" = "after" ]; then
      PATH="$PATH:$1"
    else
      PATH="$1:$PATH"
    fi
  fi
}

which_shell() {
  if [ -n "$ZSH_VERSION" ]; then
    echo "ZSH $ZSH_VERSION"
  fi

  if [ -n "$BASH_VERSION" ]; then
    echo "BASH $BASH_VERSION"
  fi
}

# Function to extract version from a path
extract_version_from_path() {
    local path="$1"
    local version=${path##*-}  # Extracts the substring after the last '-'
    echo $version
}

init_rust() {
  # Cargo for Rust
  if [ -d $HOME/.cargo/bin ]; then
    pathmunge $HOME/.cargo/bin
    echo $(rustc -V)
    export RUST_BACKTRACE=1
  fi
}



set_dart_bin() {
  if test -d "$HOME/.pub-cache/bin"; then
    echo "dart bin found"
    pathmunge $HOME/.pub-cache/bin
  fi
}

set_lua_bin() {
  if test -d "$HOME/.luaver"; then
    echo "luaver"
    . ~/.luaver/luaver
  fi

  # find the version of lua rocks and use that.
  zsh_lua_home=$(find $HOME/.luarocks/lib/luarocks -type d -name 'rocks-*' | sort -V | tail -1)
  if [ -d "$zsh_lua_home" ]; then
    zsh_luarocks_version=$(extract_version_from_path $zsh_lua_home)
    echo "LuaRocks version: $zsh_luarocks_version"

    # Recursively find all 'bin' folders in the directory
    find "$zsh_lua_home" -type d -name 'bin' | while read -r bin; do
      pathmunge "$bin"
    done
  fi
}

set_nvm() {
  if test -d "$HOME/.nvm"; then
    export NVM_DIR=$HOME/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    echo "nvm $(nvm --version)"
  else
    echo "nvm not found, installing, restart shell when done"
    # using githubusercontent to always get the latest from master
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  fi
}

set_wsl_links() {
  ln -s /mnt/c/Projects $HOME/Projects

}

# stupid ubuntu bug after hibernate
reset_touchpad() {
  sudo rmmod psmouse
  sudo modprobe psmouse
}



update_ubuntu() {
  sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo apt autoremove && sudo apt autoclean
}



update_os() {
  local CURRENTDIR=$(pwd)

  update_repos




  echo "update nvm"
  # using githubusercontent to always get the latest from master
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

  echo "update npm"
  node_update_npm_latest 
  sudo npm cache clean -f
  # sudo npm install --location=global n
  sudo n latest

  upgrade_flutter

  

  

  $HELPER_DOTFILES_HOME/install/vscode.sh

  # sdkman.io TODO move to java maintain script
  sdk selfupdate

  cd $CURRENTDIR
}

update_alacritty() {
  local CURRENTDIR=$(pwd)

  if test -d "$HOME/Projects/src/github.com/alacitty/alacritty"; then
    echo "github.com/alacitty/alacritty"
    cd $HOME/Projects/src/github.com/alacitty/alacritty
    git reset --hard && git pull -f && git prune && git gc --aggressive

    cargo build --release
    infocmp alacritty
    sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
  fi

  cd $CURRENTDIR
}


# ln -sf $HOME/Projects/src/github.com/maxgallup/tailscale-status/tailscale-status@maxgallup.github.com $HOME/.local/share/gnome-shell/extensions/tailscale-status@maxgallup.github.com

fetch_protoc() {
  local CURRENTDIR=$(pwd)
  export PROTOC_VERSION="3.17.3"
  export PROTOC_GITHUB_ROOT="https://github.com/protocolbuffers/protobuf/releases"

  cd $HOME/Downloads
  curl -LO $PROTOC_GITHUB_ROOT/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip
  mkdir -p $HOME/.local
  unzip protoc-$PROTOC_VERSION-linux-x86_64.zip -d $HOME/.local

  cd $CURRENTDIR
}

# attach to an existing tmux sessions, if does not exist, cleaning create one
tmux_default() {
  if [ -z "$TMUX" ]; then
    # base_session=$HOSTNAME
    base_session=$USER
    # Create a new session if it doesn't exist
    tmux has-session -t $base_session || tmux new-session -d -s $base_session
    # Are there any clients connected already?
    client_cnt=$(tmux list-clients | wc -l)
    if [ $client_cnt -ge 1 ]; then
      session_name=$base_session"-"$client_cnt
      tmux new-session -d -t $base_session -s $session_name
      tmux -2 attach-session -t $session_name \; set-option destroy-unattached
    else
      tmux -2 attach-session -t $base_session
    fi
  fi
}
