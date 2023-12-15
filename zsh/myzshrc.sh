export PATH=$HOME/bin:/usr/local/bin:$PATH

# loading dependancies if not exist
if test -d "$HOME/.oh-my-zsh"; then
else
  echo "oh my zsh not found, fetching"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
#ZSH_THEME="simple"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000

fpath=(~/.zsh/completion $fpath)

echo "-- welcome $(whoami) - Loading zsh --"

# Set GPG
export GPG_TTY=$(tty)

if [[ "$OSTYPE" == "darwin"* ]]; then
  alias gpg='gpg'
else
  alias gpg='gpg2'
fi

## set git cache to store password for ssh
git config --global credential.helper 'cache --timeout=9999999999999999999'


# Load Helpers
# Function to load .sh files from given directories
local function load_sh_files() {
    for dir in "$@"; do
        if [ -d "$dir" ]; then
            for f in "$dir"/*.sh; do
                . "$f"
            done
        fi
    done
}

# Directories to load .sh files from
directories=(
    "$HELPER_DOTFILES_HOME/helpers"
    "$HELPER_DOTFILES_HOME/bash/helpers"
    "$HOME/Projects/helpers/mydotfiles/bash"
)

# Load .sh files from the specified directories
load_sh_files "${directories[@]}"

# hoping this removes the history on reload
unsetopt share_history

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

if [[ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
else
  # zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

if [[ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
else
  # zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  git-prompt
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker
  docker-compose
  kubectl
)

ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh
source <(kubectl completion zsh)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}*"

if [ -d "$HOME/.goenv/bin" ]; then
  pathmunge $HOME/.goenv/bin
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
fi

if [ -d "$HOME/.rbenv/shims" ]; then
  pathmunge $HOME/.rbenv/shims
fi

if [ -d "$HOME/.rbenv/bin" ]; then
  pathmunge $HOME/.rbenv/bin
  eval "$(rbenv init -)"

  if rbenv -v >/dev/null; then
    rbenv -v
    ruby -v
  fi
fi

# initalize helpers and variables
go_init
java_setup
set_flutter_bin
set_dart_bin
set_lua_bin
set_nvm
init_rust

#export GITHUB_TOKEN=ad13cc0ddbd2a33a8a6e9d1c64c20261c0c3fd31

# added bin for yarn npm applications
pathmunge $HOME/.yarn/bin

# add pip location to path
pathmunge $HOME/.local.bin

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Locate the highest Python version in the Library and add it to the PATH
  highest_python_bin=$(find $HOME/Library/Python -type d -name 'bin' | sort -V | tail -1)
  if [ -d "$highest_python_bin" ]; then
    echo "Python $highest_python_bin bin found"
    pathmunge "$highest_python_bin"
  fi
fi


#dotnet core
# installed via https://docs.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install
if [ -d "$HOME/.dotnet" ]; then
  pathmunge $HOME/.dotnet
fi

#pathmunge $HOME/.local/bin

pathmunge $HOME/.zsh/plugins/zsh-git-prompt/src/.bin

pathmunge "/usr/local/bin"

pathmunge $HOME/.npm-global/bin

pathmunge $HOME/.local/bin

pathmunge $HOME/.local/share/nvim/site/pack/packer/start

#
# Editors
#

if [[ -z "$EDITOR" ]]; then
  export EDITOR='nano'
fi
if [[ -z "$VISUAL" ]]; then
  export VISUAL='nano'
fi
if [[ -z "$PAGER" ]]; then
  export PAGER='less'
fi

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Ruby Gem
mkdir -p $HOME/gems
export GEM_HOME=$HOME/gems

#dotnet core #opt-out of telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# AWS-Okta
# TODO: might be needed for linux
#export AWS_OKTA_BACKEND=secret-service
#export AWS_OKTA_BACKEND=pass

export APPLE_SSH_ADD_BEHAVIOR=true

echo -e "\nLoading keychain"
eval $(ssh-agent -s)
ssh-add

if [ -d "$HOME/.ssh" ]; then
  chmod 700 ~/.ssh
fi

if test -f "$HOME/.ssh/authorized_keys"; then
  chmod 644 ~/.ssh/authorized_keys
fi

# keychain --clear # only if we want to rest the keys
# keychain fun
if test -f "$HOME/.ssh/id_rsa"; then
  chmod 600 ~/.ssh/id_rsa
  chmod 644 ~/.ssh/id_rsa.pub
  ssh-add ~/.ssh/id_rsa
  #eval $(keychain --eval --agents ssh id_rsa)
fi

if test -f "$HOME/.ssh/id_rsa_nil"; then
  chmod 600 ~/.ssh/id_rsa_nil
  chmod 644 ~/.ssh/id_rsa_nil.pub
  ssh-add ~/.ssh/id_rsa_nil
  #eval $(keychain --eval --agents ssh id_rsa_nil)
fi

# if test -f "$HOME/.ssh/ids_id_rsa"; then
#   chmod 600 ~/.ssh/ids_id_rsa
#   chmod 644 ~/.ssh/ids_id_rsa.pub
#   ssh-add -K ~/.ssh/ids_id_rsa
#   #eval $(keychain --eval --agents ssh ids_id_rsa)
# fi

# if test -f "$HOME/.ssh/id_cfa_sso"; then
#   chmod 600 ~/.ssh/id_cfa_sso
#   chmod 644 ~/.ssh/id_cfa_sso.pub
#   ssh-add -K ~/.ssh/id_cfa_sso 2>/dev/null
# #   #eval $(keychain --eval --agents ssh $HOME/.ssh/id_cfa_sso)
# fi

# if test -f "$HOME/.ssh/id_ed25519"; then
#   chmod 600 ~/.ssh/id_ed25519
#   chmod 644 ~/.ssh/id_ed25519.pub
#   ssh-add -K ~/.ssh/id_ed25519
#   #eval $(keychain --eval --agents ssh $HOME/.ssh/id_ed25519)
# fi

if test -f "$HOME/.ssh/ssh_iv_ed25519"; then
  chmod 600 ~/.ssh/ssh_iv_ed25519
  chmod 644 ~/.ssh/ssh_iv_ed25519.pub
  ssh-add ~/.ssh/ssh_iv_ed25519 2>/dev/null
  #eval $(keychain --eval --agents ssh $HOME/.ssh/id_ed25519)
fi

if test -f "$HOME/.ssh/id_gitlab_ed25519"; then
  chmod 600 ~/.ssh/id_gitlab_ed25519
  chmod 644 ~/.ssh/id_gitlab_ed25519.pub
  ssh-add ~/.ssh/id_gitlab_ed25519
  #eval $(keychain --eval --agents ssh $HOME/.ssh/id_ed25519)
fi

ssh-add ~/.ssh/*rsa 2>/dev/null
ssh-add ~/.ssh/*ed25519 2>/dev/null

#cd $HOME


# start TMUX
#tmux_default

# Add to .zshrc
# Source global definitions
# if [ -f $HELPER_DOTFILES_HOME/zsh/myzshrc.sh ]; then
#    echo "Loading My Scripts"
#    . $HELPER_DOTFILES_HOME/zsh/myzshrc.sh
# fi

#echo "---<"
# Powerline configuration
if [ -f /usr/share/powerline/bindings/zsh/powerline.zsh ]; then
  # echo "powerline found"
  # powerline-daemon -q
  # POWERLINE_BASH_CONTINUATION=1
  # POWERLINE_BASH_SELECT=1
  source /usr/share/powerline/bindings/zsh/powerline.zsh
else
  function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
  }

  export PROMPT='%n@%m[%~]:$(git_prompt_info)$(prompt_char)%{$reset_color%} '

  RPROMPT=""
fi

echo "-------------------------------------"