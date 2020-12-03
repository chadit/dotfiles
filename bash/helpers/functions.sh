
# reset_terminal will clear the screens and rest the terminal
reset_terminal1(){
  tmux clear-history;
  reset
  clear;

  # if [ -f "$HOME/Projects/helpers/myzshrc.sh" ]; then
  #   source $HOME/Projects/helpers/myzshrc.sh
  # fi
}

# pathmunge adds items to the path, verifies if it exist on the path first.
# pathmunge /sbin/             ## Add to the start; default
# pathmunge /usr/sbin/ after   ## Add to the end
pathmunge () {
  if ! echo "$PATH" | grep -Eq "(^|:)$1($|:)" ; then
    if [ "$2" = "after" ] ; then
      PATH="$PATH:$1"
    else
      PATH="$1:$PATH"
    fi
  fi
}

which_shell(){
  if [ -n "$ZSH_VERSION" ]; then
    echo "ZSH $ZSH_VERSION"
  fi

  if [ -n "$BASH_VERSION" ]; then
    echo "BASH $BASH_VERSION"
  fi
}

init_golang(){
 # echo "init go"
  # GOVERSION=$1
  # if [ -d /usr/go/ ]; then
  #   export GOPATH=/home/chadit/Projects
  #   export GOROOT="/usr/go"
  #   export GOCACHE=off # turns off go's test cacheing, can cause test to give unexpected results
  #   #export GO111MODULE=on
  #   export GO111MODULE=auto
  #   pathmunge $GOROOT/bin after
  #   pathmunge $GOPATH/bin after
  # fi

  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        export GOPATH=/home/chadit/Projects
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        export GOPATH=/Users/chadit/Projects
elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
else
        # Unknown.
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
    #export GO111MODULE=auto
    pathmunge $GOROOT after
    pathmunge $GOPATH after
    pathmunge $GOROOT/bin after
    pathmunge $GOPATH/bin after
  # fi
}

list_golang(){
  find /usr/lib64/ -maxdepth 1 -type d -name 'go*' | sort
}

# lua
pathmunge "/home/chadit/luarocks-3.3.1/lua_modules/bin" after
pathmunge "/home/chadit/.luarocks/lib/luarocks/rocks-5.3" after


# removes sync conflicts that can happen from syncthing or pcloud
remove_sync_conflicts(){
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

update_os(){
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

  # refresh snap packages
  echo "snap refresh"
  sudo snap refresh

  # cleanup docker
  echo "docker cleanup"
  docker_cleanup_volumes
}

update_system_symbolic(){
  ln -sf $HOME/Projects/helpers/mydotfiles/bash/Git/.gitconfig
  sudo ln -sf $HOME/Projects/helpers/mydotfiles/bash/Git/.gitconfig

  mkdir -p $HOME/.config/alacritty
  ln -sf $HOME/Projects/src/github.com/chadit/dotfiles/home/.config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml

  ln -sf $HOME/Projects/src/github.com/chadit/dotfiles/home/.zsh /home/chadit/.zsh

  if [ -f $HOME/Projects/src/github.com/chadit/dotfiles/home/.zsh/.zsh ]; then
    sudo rm $HOME/Projects/src/github.com/chadit/dotfiles/home/.zsh/.zsh
  fi

  #if [ -f $HOME/Projects/helpers/mydotfiles/bash/Git/.gitconfig ]; then
  #  sudo rm $HOME/Projects/helpers/mydotfiles/bash/Git/.gitconfig
  #fi

  # main zshrc file
  ln -sf /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.zshrc /home/chadit/.zshrc

  ln -sf /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.vim /home/chadit/.vim

  if [ -f $HOME/Projects/src/github.com/chadit/dotfiles/home/.vim/.vim ]; then
    sudo rm $HOME/Projects/src/github.com/chadit/dotfiles/home/.vim/.vim
  fi

  ln -sf /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.vimrc /home/chadit/.vimrc
  ln -sf /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.vimrc.local /home/chadit/.vimrc.local
  ln -sf /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.vimrc.local.bundles /home/chadit/.vimrc.local.bundles

  ln -sf /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.tmux /home/chadit/.tmux

  if [ -f $HOME/Projects/src/github.com/chadit/dotfiles/home/.tmux/.tmux ]; then
    sudo rm $HOME/Projects/src/github.com/chadit/dotfiles/home/.tmux/.tmux
  fi

  ln -sf /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.tmux.conf /home/chadit/.tmux.conf

  ln -sf /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.ssh /home/chadit/.ssh

  if [ -f $HOME/Projects/src/github.com/chadit/dotfiles/home/.ssh/.ssh ]; then
    sudo rm $HOME/Projects/src/github.com/chadit/dotfiles/home/.ssh/.ssh
  fi
}

update_system_exec(){
  find /home/chadit/Projects/helpers -type f -name "*.sh" -exec sudo chmod +x {} \;
  find /home/chadit/Projects/helpers -type f -name "*.zsh" -exec sudo chmod +x {} \;
  find /home/chadit/Projects/bin -type f -exec sudo chmod +x {} \;
}

set_shutDown(){
  sudo shutdown -P 01:00
}

update_apps(){
  # install update rust
  curl https://sh.rustup.rs -sSf | sh

  source $HOME/.cargo/env

  # Alacritty
  cd /home/chadit/Projects/src/github.com/jwilm/alacritty && echo `pwd` && git fetch --prune && git reset --hard @{upstream} && git clean -x -d -f && git prune && git gc --aggressive && git pull
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
  sudo cp -f /home/chadit/Projects/src/github.com/jwilm/alacritty/alacritty-completions.zsh /usr/share/zsh/functions/Completion/X/_alacritty
}

build_nilcore(){
  local CURRENTDIR=`pwd`
  local BASEDIR="/mnt/c/Projects/src/github.com/chadit/NilsCoreAPI/"
  cd $BASEDIR
  zip "/mnt/c/Projects/src/github.com/chadit/build/NilsReactionCore_$1.zip" module.def *.lua
  cd $CURRENTDIR
}

# attach to an existing tmux sessions, if does not exist, cleaning create one
tmux_default(){
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
