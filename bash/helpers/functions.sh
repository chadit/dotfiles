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

init_rust() {
  # Cargo for Rust
  if [ -d $HOME/.cargo/bin ]; then
    pathmunge $HOME/.cargo/bin
    echo $(rustc -V)
    export RUST_BACKTRACE=1
  fi
}

init_golang() {
  export GOPATH=$HOME/Projects
  if [ -d /usr/lib64/golang/ ]; then
    export GOROOT="/usr/lib64/golang"
  fi

  if [ -d /usr/local/go ]; then
    export GOROOT="/usr/local/go"
  fi

  #export GOCACHE=off <-- required on by default as of 1.12
  GOFLAGS="-count=1" # <-- suppose to prevent test from being cached
  export GO111MODULE=on
  export GOBIN=$GOPATH/bin
  pathmunge $GOROOT
  pathmunge $GOPATH
  pathmunge $GOROOT/bin
  pathmunge $GOPATH/bin

  echo $(go version)
}

list_golang() {
  find /usr/lib64/ -maxdepth 1 -type d -name 'go*' | sort
}

init_java_sdk() {
  if test -f "$HOME/.sdkman/bin/sdkman-init.sh"; then
    # curl -s "https://get.sdkman.io" | bash
    # shellcheck source=/dev/null # to ignore the error BASH Language Server
    source "$HOME/.sdkman/bin/sdkman-init.sh"
  fi
}

set_java_home() {
  if test -f "/usr/libexec/java_home"; then
    # echo "test"
    export JAVA_HOME=$(/usr/libexec/java_home)
    pathmunge $JAVA_HOME/bin
  fi

  if test -d "/usr/lib/jvm/java-16-openjdk-amd64"; then
    # echo "test"
    export JAVA_HOME=/usr/lib/jvm/java-16-openjdk-amd64
    pathmunge $JAVA_HOME/bin
  fi

  if test -d "/usr/lib/jvm/java-17-openjdk-amd64"; then
    # echo "test"
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
    pathmunge $JAVA_HOME/bin
  fi

  if test -d "/usr/lib/jvm/java-18-openjdk-amd64"; then
    # echo "test"
    export JAVA_HOME=/usr/lib/jvm/java-18-openjdk-amd64
    pathmunge $JAVA_HOME/bin
  fi

  if test -d "/usr/lib/jvm/java-19-openjdk-amd64"; then
    # echo "test"
    export JAVA_HOME=/usr/lib/jvm/java-19-openjdk-amd64
    pathmunge $JAVA_HOME/bin
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

  if test -d "$HOME/luarocks-3.3.1/lua_modules/bin"; then
    echo "lua rocks 3.3.1 bin found"
    pathmunge $HOME/luarocks-3.3.1/lua_modules/bin
  fi

  if test -d "$HOME/.luarocks/lib/luarocks/rocks-5.3"; then
    echo "lua rocks 5.3 bin found"
    pathmunge $HOME/.luarocks/lib/luarocks/rocks-5.3

    if [ -d "$HOME/.luarocks/lib/luarocks/rocks-5.3/luaformatter/scm-1/bin" ]; then
      pathmunge $HOME/.luarocks/lib/luarocks/rocks-5.3/luaformatter/scm-1/bin
    fi
  fi

  if test -d "$HOME/.luarocks/lib/luarocks/rocks-5.4"; then
    echo "lua rocks 5.4 bin found"
    pathmunge $HOME/.luarocks/lib/luarocks/rocks-5.4

    if [ -d "$HOME/.luarocks/lib/luarocks/rocks-5.4/luaformatter/scm-1/bin" ]; then
      pathmunge $HOME/.luarocks/lib/luarocks/rocks-5.4/luaformatter/scm-1/bin
    fi
  fi

}

set_nvm() {
  if test -d "$HOME/.nvm"; then
    echo "nvm found"
    export NVM_DIR=$HOME/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
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

# removes sync conflicts that can happen from syncthing or pcloud
remove_sync_conflicts() {
  if [[ -d /mnt/c/Projects ]]; then
    echo "/mnt/c/Projects"
    find /mnt/c/Projects -name "*.sync-conflict*"
    find /mnt/c/Projects -name "*.sync-conflict*" -exec rm -rf {} \;

    find /mnt/c/Projects -name "*.syncthing*"
    find /mnt/c/Projects -name "*.syncthing*" -exec rm -rf {} \;

    find /mnt/c/Projects -name "*conflicted*"
    find /mnt/c/Projects -name "*conflicted*" -exec rm -rf {} \;
  fi

  find $HOME/Projects -name "*.sync-conflict*"
  find $HOME/Projects -name "*.sync-conflict*" -exec rm -rf {} \;
  #find $HOME/.vim -name "*.sync-conflict*"
  #find $HOME/.vim -name "*.sync-conflict*" -exec rm -rf {} \;
  find $HOME/Projects -name "*.syncthing*"
  find $HOME/Projects -name "*.syncthing*" -exec rm -rf {} \;
  find $HOME/Projects -name "*conflicted*"
  find $HOME/Projects -name "*conflicted*" -exec rm -rf {} \;

}

update_ubuntu() {
  sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo apt autoremove && sudo apt autoclean
}

update_os() {
  local CURRENTDIR=$(pwd)

  update_repos

  # cleanup docker
  echo "docker cleanup"
  docker_cleanup_volumes

  echo "update npm"
  sudo npm cache clean -f
  sudo npm install --location=global n
  sudo n latest

  #sudo snap refresh
  #sudo snap refresh snap-store
  sudo flatpak update

  #go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

  # cd $HOME/Projects/src/github.com/chadit/Environment/workstation
  # ansible-playbook playbook.yml
  #cd $HOME/Projects/src/github.com/chadit/Environment
  #make run-workstation

  sudo pacman -Syyu --noconfirm

  $HOME/Projects/src/github.com/chadit/dotfiles/install/vscode.sh

  install_kubectl

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

update_system_symbolic() {
  ln -sf $HOME/Projects/helpers/mydotfiles/bash/Git/.gitconfig
  sudo ln -sf $HOME/Projects/helpers/mydotfiles/bash/Git/.gitconfig

  mkdir -p $HOME/.config/alacritty
  ln -sf $HOME/Projects/src/github.com/chadit/dotfiles/home/.config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

  ln -sf $HOME/Projects/src/github.com/chadit/dotfiles/home/.zsh $HOME/.zsh

  if [ -f $HOME/Projects/src/github.com/chadit/dotfiles/home/.zsh/.zsh ]; then
    sudo rm $HOME/Projects/src/github.com/chadit/dotfiles/home/.zsh/.zsh
  fi

  #if [ -f $HOME/Projects/helpers/mydotfiles/bash/Git/.gitconfig ]; then
  #  sudo rm $HOME/Projects/helpers/mydotfiles/bash/Git/.gitconfig
  #fi

  # main zshrc file
  ln -sf $HOME/Projects/src/github.com/chadit/dotfiles/home/.zshrc $HOME/.zshrc

  ln -sf $HOME/Projects/src/github.com/chadit/dotfiles/home/.vim $HOME/.vim

  # if [ -f $HOME/Projects/src/github.com/chadit/dotfiles/home/.vim/.vim ]; then
  #   sudo rm $HOME/Projects/src/github.com/chadit/dotfiles/home/.vim/.vim
  # fi

  ln -sf $HOME/Projects/src/github.com/chadit/dotfiles/home/.vimrc $HOME/.vimrc
  ln -sf $HOME/Projects/src/github.com/chadit/dotfiles/home/.vimrc.local $HOME/.vimrc.local
  ln -sf $HOME/Projects/src/github.com/chadit/dotfiles/home/.vimrc.local.bundles $HOME/.vimrc.local.bundles

  ln -sf $HOME/Projects/src/github.com/chadit/dotfiles/home/.tmux $HOME/.tmux

  if [ -f $HOME/Projects/src/github.com/chadit/dotfiles/home/.tmux/.tmux ]; then
    sudo rm $HOME/Projects/src/github.com/chadit/dotfiles/home/.tmux/.tmux
  fi

  ln -sf $HOME/Projects/src/github.com/chadit/dotfiles/home/.tmux.conf $HOME/.tmux.conf
}

## using vim plugin addon handler
setup_youcompleteme() {
  local CURRENTDIR=$(pwd)

  if [ -d "$HOME/.vim/plugged/YouCompleteMe" ]; then
    cd $HOME/.vim/plugged/YouCompleteMe
    git reset --hard
    git pull && git prune && git gc --aggressive
    python3 install.py --all
  fi

  if [ -d "$HOME/.config/nvim/plugged/YouCompleteMe" ]; then
    cd $HOME/.config/nvim/plugged/YouCompleteMe
    git reset --hard
    git pull && git prune && git gc --aggressive
    python3 install.py --all
  fi
  #cd ~/.config/nvim/plugged/YouCompleteMe

  cd $CURRENTDIR
}

update_system_exec() {
  find $HOME/Projects/helpers -type f -name "*.sh" -exec sudo chmod +x {} \;
  find $HOME/Projects/helpers -type f -name "*.zsh" -exec sudo chmod +x {} \;
  find $HOME/Projects/bin -type f -exec sudo chmod +x {} \;
}

set_shutDown() {
  sudo shutdown -P 01:00
}

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

generate_lua_table() {
  local tableName=$1
  local filePath=$2
  local fileNames=("$3")

  i=1
  echo "    $tableName = {" >>$filePath

  for eachfile in $fileNames; do
    file_name="${eachfile##*/}"
    echo "        [$i] = \"$file_name\"," >>$filePath
    ((i++))
  done
  echo "    }," >>$filePath
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

# Load private functions
FILE=$HOME/Projects/helpers/mydotfiles/bash
if [ -d "$FILE" ]; then
  for f in $FILE/*.sh; do
    # echo -n ".."
    # echo $f
    . $f
  done

  # echo -n "..........................."
fi
