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

set_wsl_links() {
  ln -s /mnt/c/Projects $HOME/Projects

}

# stupid ubuntu bug after hibernate
reset_touchpad() {
  sudo rmmod psmouse
  sudo modprobe psmouse
}

# ln -sf $HOME/Projects/src/github.com/maxgallup/tailscale-status/tailscale-status@maxgallup.github.com $HOME/.local/share/gnome-shell/extensions/tailscale-status@maxgallup.github.com

fetch_protoc() {
  local CURRENTDIR=$(pwd)
  #export PROTOC_VERSION="25.3"
  #export PROTOC_VERSION="3.6.1"
  export PROTOC_GITHUB_ROOT="https://github.com/protocolbuffers/protobuf/releases"

  # https://github.com/protocolbuffers/protobuf/releases/download/v25.3/protoc-25.3-linux-x86_64.zip

  cd $HOME/Downloads
  curl -LO $PROTOC_GITHUB_ROOT/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip
  mkdir -p $HOME/.local
  unzip protoc-$PROTOC_VERSION-linux-x86_64.zip -d $HOME/.local

  cd $CURRENTDIR
}
