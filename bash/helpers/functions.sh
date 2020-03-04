
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

  if [ -d /usr/lib64/golang/ ]; then
    export GOPATH=/home/chadit/Projects
    export GOROOT="/usr/lib64/golang"
    # if [ -n "$GOVERSION" ]; then
    #   export GOROOT="/usr/lib64/golang$GOVERSION"
  fi

  if [ -d /usr/local/go ]; then
    export GOPATH=/Users/chadengland/Projects
    export GOROOT="/usr/local/go"
    # if [ -n "$GOVERSION" ]; then
    #   export GOROOT="/usr/lib64/golang$GOVERSION"
  fi

    #export GOCACHE=off <-- required on by default as of 1.12
    GOFLAGS="-count=1" # <-- suppose to prevent test from being cached
    #export GO111MODULE=on
    export GO111MODULE=auto
    pathmunge $GOROOT after
    pathmunge $GOPATH after
    pathmunge $GOROOT/bin after
    pathmunge $GOPATH/bin after

    pathmunge "/home/chadit/Projects/src/github.com/vlang/v" after
  # fi
}

list_golang(){
  find /usr/lib64/ -maxdepth 1 -type d -name 'go*' | sort
}

refresh_vim(){
  git_update_folder /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.vim/bundle/
  sudo chown -R $(whoami) /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.vim

  #local CURRENTDIR=`pwd`
  #cd /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.vim/bundle/YouCompleteMe/third_party/ycmd
  #git checkout master
  #git pull
  #cd /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.vim/bundle/YouCompleteMe
  #git submodule update --init --recursive
  #cd $CURRENTDIR

  #sudo chown -R $(whoami) /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.vim

  #/home/chadit/Projects/src/github.com/chadit/dotfiles/home/.vim/bundle/YouCompleteMe/install.py --go-completer --cs-completer --rust-completer
  #sudo chown -R $(whoami) /home/chadit/Projects/src/github.com/chadit/dotfiles/home/.vim

# installs prettier 
 # yarn global add prettier
}

# removes sync conflicts that can happen from syncthing or pcloud
remove_sync_conflicts(){
  find $HOME/Projects -name "*.sync-conflict*"
  find $HOME/Projects -name "*.sync-conflict*" -exec rm -rf {} \;
  find $HOME/.vim -name "*.sync-conflict*"
  find $HOME/.vim -name "*.sync-conflict*" -exec rm -rf {} \;
  find $HOME/Projects -name "*.syncthing*"
  find $HOME/Projects -name "*.syncthing*" -exec rm -rf {} \;
  find $HOME/Projects -name "*conflicted*"
  find $HOME/Projects -name "*conflicted*" -exec rm -rf {} \;

  # find /home/chadit -name "*.sync-conflict*"
  # find /home/chadit -name "*.sync-conflict*" -exec rm -rf {} \;
  # find /home/chadit -name "*conflicted*"
  # find /home/chadit -name "*conflicted*" -exec rm -rf {} \;
  # find /home/chadit -name "*conflicted copy*"
}

update_os(){
  #Solus
  if [ -f /etc/solus-release ]; then
    sudo eopkg upgrade -y 
  fi

  #Fedora
  python -mplatform | grep -qi Fedora && sudo dnf clean all && sudo dnf upgrade -y && sudo dnf update -y 
  #Ubuntu
  #python -mplatform | grep -qi Ubuntu && sudo apt update -y && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y
  #python -mplatform | grep -qi Ubuntu && sudo apt update -y && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo do-release-upgrade && sudo apt autoremove -y && sudo apt autoclean -y
  #python -mplatform | grep -qi Ubuntu && sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y
  python -mplatform | grep -qi Ubuntu && sudo apt update -y && sudo apt upgrade -y 
   
 # python -mplatform | grep -qi Manjaro && sudo pacman-db-upgrade && sudo pacman-optimize && sync && sudo pacman -Syyu -y && sudo yaourt -Sy
  #Manjaro
  # python -mplatform | grep -qi Manjaro && sudo pacman-db-upgrade && sudo pacman-optimize && sync && sudo pacman -Syyu -y
  python -mplatform | grep -qi Manjaro && sudo pacman-db-upgrade && sudo pacman -Syyu #&& yay -Syyu

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

# (c) 2007 stefan w. GPLv3          
function up {
ups=""
for i in $(seq 1 $1)
do
        ups=$ups"../"
done
cd $ups
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
