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


  $HELPER_DOTFILES_HOME/install/vscode.sh

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
