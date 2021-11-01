# /etc/bashrc

# https://github.com/lyze/posh-git-sh
if [ -f "$HOME/Projects/src/github.com/lyze/posh-git-sh/git-prompt.sh" ]; then
  source $HOME/Projects/src/github.com/lyze/posh-git-sh/git-prompt.sh

  #PoshGit
  PROMPT_COMMAND='__posh_git_ps1 "\u@\h:\w" "\\\$ ";'$PROMPT_COMMAND
  #end PoshGit
fi

echo "welcome $(whoami) - Loading My $SHELL Scripts" 
# Load Helpers
for f in $HOME/Projects/src/github.com/chadit/dotfiles/bash/helpers/*.sh; do
  echo -n ".."
 # echo $f  
   . $f
done

pathmunge $HOME/.goenv/bin
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

# initalize helpers and variables
init_golang

# added bin for yarn npm applications
pathmunge $HOME/.yarn/bin after
# added bin for yarn npm applications
pathmunge $HOME/.yarn/bin after
# add pip location to path
pathmunge $HOME/.local.bin after
# Cargo for Rust
pathmunge $HOME/.cargo/bin after
# Ruby
pathmunge $HOME/gems/bin/ after


# Set Vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# Ruby Gem
mkdir -p $HOME/gems
export GEM_HOME=$HOME/gems

#dotnet core #opt-out of telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

#source <(kubectl completion bash)

go_check_folder(){
  go list ./... | grep -v vendor | xargs go vet -v
}

# sudo rsync -aAXv --delete /run/media/chadit/Backup/ --exclude '$RECYCLE.BIN' --exclude 'System Volume Information' --exclude '000'  /run/media/chadit/Shared
# sudo rsync -aAXv /run/media/chadit/Shared/ /run/media/chadit/Backup/

# sudo rsync -aAXv $HOME/pCloudDrive /run/media/chadit/Backup/

set_shutDown(){
  sudo shutdown -P 01:00
}

if [ ! -d $BASHPRIVATE ]; then
    echo "private repo not set"
else
  # Load scripts from private repo, $BASHPRIVATE is a private Variable set in /etc/profile
  for f in $BASHPRIVATE/*.sh; do
    echo -n ".."
   # echo $f  
  #   . $f
  done
fi

#if [ -n "$BASH_VERSION" ]; then
   # assume Bash
  # . $HOME/Projects/src/github.com/jwilm/alacritty/alacritty-completions.bash
#fi

echo ""

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi


# Source global definitions
#if [ -f $HOME/Projects/src/github.com/chadit/dotfiles/bash/mybashrc.sh ]; then
#    echo "Loading My Scripts"
#    . $HOME/Projects/src/github.com/chadit/dotfiles/bash/mybashrc.sh
#fi