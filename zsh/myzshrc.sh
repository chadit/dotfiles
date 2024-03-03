# start tmux automatically
# if which tmux >/dev/null 2>&1; then
#   # if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
#   if [[ $- =~ i ]] && [[ -z "$TMUX" ]]; then
#     tmux attach-session -t $HOST || tmux new-session -s $HOST
#   fi
# fi


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
HISTSIZE=100000
SAVEHIST=100000

fpath=(~/.zsh/completion $fpath)

echo "---- Welcome $(whoami) - Loading zsh ----"

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
  echo "zsh-syntax-highlighting not found, fetching"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

if [[ -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]]; then
else
  # zsh-autosuggestions
  echo "zsh-autosuggestions not found, fetching"
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
#source <(kubectl completion zsh)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}*"

# initalize helpers and variables
java_setup
go_setup
ruby_setup
node_setup
flutter_setup
dart_setup
rust_setup
ssh_setup
lua_setup
kube_setup


if [[ "$OSTYPE" == "darwin"* ]]; then
  # Locate the highest Python version in the Library and add it to the PATH
  highest_python_bin=$(find $HOME/Library/Python -type d -name 'bin' | sort -V | tail -1)
  if [ -d "$highest_python_bin" ]; then
    # echo "Python $highest_python_bin bin found"
    pathmunge "$highest_python_bin"
  fi
fi


#dotnet core
# installed via https://docs.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install
if [ -d "$HOME/.dotnet" ]; then
  pathmunge $HOME/.dotnet
fi

if [ -d "$HOME/.zsh/plugins/zsh-git-prompt/src/.bin" ]; then
  pathmunge $HOME/.zsh/plugins/zsh-git-prompt/src/.bin
fi

if [ -d "/usr/local/bin" ]; then
  pathmunge "/usr/local/bin"
fi

if [ -d "$HOME/.local/bin" ]; then
  pathmunge $HOME/.local/bin
fi

if [ -d "$HOME/.local/share/nvim/site/pack/packer/start" ]; then
  pathmunge $HOME/.local/share/nvim/site/pack/packer/start
fi

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
  powerline_paths=$(find $HOME/Library/Python/ -type f -path '*/zsh/powerline.zsh' 2>/dev/null)
  if [ -z "$folder_limit" ]; then
    # Sort the paths by Python version (highest version last)
    sorted_paths=$(echo "$powerline_paths" | sort -V)

    # Get the last (highest Python version) path
    newest_powerline=$(echo "$sorted_paths" | tail -n 1)

    # Check if a powerline.sh was found
    if [ -n "$newest_powerline" ]; then
      echo "Sourcing Powerline from: $newest_powerline"
      # powerline-daemon -q
      # POWERLINE_BASH_CONTINUATION=1
      # POWERLINE_BASH_SELECT=1
      source "$newest_powerline"
    fi
    # source /usr/local/lib/python3.6/site-packages/powerline/bindings/bash/powerline.sh
  else
    echo "Powerline not found loading default."

    function prompt_char {
      git branch >/dev/null 2>/dev/null && echo '±' && return
      hg root >/dev/null 2>/dev/null && echo '☿' && return
      echo '○'
    }

    export PROMPT='%n@%m[%~]:$(git_prompt_info)$(prompt_char)%{$reset_color%} '

    RPROMPT=""
  fi
fi

# reset the path hash to avoid issues with zsh
hash -r
echo "-------------------------------------"
