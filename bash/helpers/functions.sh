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

init_golang() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export GOPATH=$HOME/Projects
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OSX
    export GOPATH=$HOME/Projects
    #elif [[ "$OSTYPE" == "cygwin" ]]; then
    # POSIX compatibility layer and Linux environment emulation for Windows
    #elif [[ "$OSTYPE" == "msys" ]]; then
    # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    #elif [[ "$OSTYPE" == "win32" ]]; then
    # I'm not sure this can happen.
    #elif [[ "$OSTYPE" == "freebsd"* ]]; then
    # ...
    #else
    # Unknown.
    #       echo "not supported"
  fi

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
  #export GO111MODULE=auto
  pathmunge $GOROOT after
  pathmunge $GOPATH after
  pathmunge $GOROOT/bin after
  pathmunge $GOPATH/bin after
  # fi
}

list_golang() {
  find /usr/lib64/ -maxdepth 1 -type d -name 'go*' | sort
}

set_java_home() {
  if test -f "/usr/libexec/java_home"; then
   # echo "test"
    export JAVA_HOME=$(/usr/libexec/java_home)
    pathmunge $JAVA_HOME/bin after
  fi

  if test -d "/usr/lib/jvm/java-16-openjdk-amd64"; then
   # echo "test"
    export JAVA_HOME=/usr/lib/jvm/java-16-openjdk-amd64
    pathmunge $JAVA_HOME/bin after
  fi

}

# lua
pathmunge "$HOME/luarocks-3.3.1/lua_modules/bin" after
pathmunge "$HOME/.luarocks/lib/luarocks/rocks-5.3" after

# stupid ubuntu bug after hibernate
reset_touchpad() {
  sudo rmmod psmouse
  sudo modprobe psmouse
}

# removes sync conflicts that can happen from syncthing or pcloud
remove_sync_conflicts() {
  if test -d "/mnt/c/Projects"; then
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

update_os() {
  # #Solus
  # if [ -f /etc/solus-release ]; then
  #   sudo eopkg upgrade -y
  # fi

  #sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y

  #Fedora
  # python3 -mplatform | grep -qi Fedora && sudo dnf clean all && sudo dnf upgrade -y && sudo dnf update -y
  #Ubuntu
  #python3 -mplatform | grep -qi Ubuntu && sudo apt update -y && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y
  #python3 -mplatform | grep -qi Ubuntu && sudo apt update -y && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo do-release-upgrade && sudo apt autoremove -y && sudo apt autoclean -y
  #python3 -mplatform | grep -qi Ubuntu && sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y
  lsb_release -i | grep -qi Ubuntu && sudo apt update -y && sudo apt upgrade -y

  # python3 -mplatform | grep -qi Manjaro && sudo pacman-db-upgrade && sudo pacman-optimize && sync && sudo pacman -Syyu -y && sudo yaourt -Sy
  #Manjaro
  # python3 -mplatform | grep -qi Manjaro && sudo pacman-db-upgrade && sudo pacman-optimize && sync && sudo pacman -Syyu -y
  #python3 -mplatform | grep -qi Manjaro && sudo pacman-db-upgrade && sudo pacman -Syyu #&& yay -Syyu

  #pacman -S -f firefox  (force a package)
  #pacman -Ss firefox | grep installed returns how it was installed

  # sudo pacman-mirrors -f 5 && sudo pacman -Syy && sudo pacman-optimize && sudo sync && yaourt -Syyua

  # echo "clean cache"
 # go clean --modcache
  

  echo "update pip"
  pip3 install --upgrade pip --user
  # pip3 install --upgrade setuptools --user

  # refresh snap packages
  echo "snap refresh"
  sudo snap refresh

  # cleanup docker
  echo "docker cleanup"
  docker_cleanup_volumes

  echo "update npm"
  sudo npm cache clean -f
  sudo npm install -g n
  sudo n latest

  # terminal built in go
  # go get -u github.com/liamg/aminal
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

  ln -sf $HOME/Projects/src/github.com/chadit/dotfiles/home/.ssh $HOME/.ssh

  if [ -f $HOME/Projects/src/github.com/chadit/dotfiles/home/.ssh/.ssh ]; then
    sudo rm $HOME/Projects/src/github.com/chadit/dotfiles/home/.ssh/.ssh
  fi
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

update_apps() {
  # install update rust
  curl https://sh.rustup.rs -sSf | sh

  source $HOME/.cargo/env

  # Alacritty
  cd $HOME/Projects/src/github.com/jwilm/alacritty && echo $(pwd) && git fetch --prune && git reset --hard @{upstream} && git clean -x -d -f && git prune && git gc --aggressive && git pull
  #cargo install cargo-deb --force
  #cargo deb --install

  # none dep
  cargo build --release
  sudo cp -f target/release/alacritty /usr/local/bin
  cp -f alacritty.desktop ~/.local/share/applications
  sudo desktop-file-install alacritty.desktop
  sudo update-desktop-database

  # if error caused by ssh authentication
  # eval `ssh-agent -s`
  # ssh-add

  # add/update zsh auto complete
  sudo cp -f $HOME/Projects/src/github.com/jwilm/alacritty/alacritty-completions.zsh /usr/share/zsh/functions/Completion/X/_alacritty
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

build_nilcore() {
  echo "NilsReactionCore.data.MadaoProfiles = {" >$HOME/Projects/src/github.com/chadit/NilsCoreAPI/data_madao.lua

  # Crafting
  local FILES=$HOME/Projects/src/github.com/nil2share/madaoprofiles/CraftProfiles/Nil-*.lua
  generate_lua_table "Crafting" $HOME/Projects/src/github.com/chadit/NilsCoreAPI/data_madao.lua "${FILES[@]}"

  # Gathering
  local FILES=$HOME/Projects/src/github.com/nil2share/madaoprofiles/GatherScheduleProfiles/Nil-*.lua
  generate_lua_table "Gathering" $HOME/Projects/src/github.com/chadit/NilsCoreAPI/data_madao.lua "${FILES[@]}"

  echo "}" >>$HOME/Projects/src/github.com/chadit/NilsCoreAPI/data_madao.lua

  local CURRENTDIR=$(pwd)
  local BASEDIR="$HOME/Projects/src/github.com/chadit/NilsCoreAPI/"
  cd $BASEDIR
  zip "$HOME/Projects/src/github.com/chadit/build/NilsReactionCore_$1.zip" module.def *.lua
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

# Load private functions
FILE=$HOME/Projects/helpers/mydotfiles/bash
if [ -d "$FILE" ]; then
  for f in $FILE/*.sh; do
    echo -n ".."
    # echo $f
    . $f
  done
fi
