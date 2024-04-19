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

if [ ! -d "${ZDOTDIR:-~}/.zsh_functions" ]; then
  mkdir -p ${ZDOTDIR:-~}/.zsh_functions
fi
fpath+=${ZDOTDIR:-~}/.zsh_functions

echo "---- Welcome $(whoami) - Loading zsh ----"

# Set GPG
export GPG_TTY=$(tty)
if command -v gpg2 >/dev/null 2>&1; then
  alias gpg='gpg2'
fi

# if [[ "$OSTYPE" == "darwin"* ]]; then
#   alias gpg='gpg'
# else
#   alias gpg='gpg2'
# fi

## set git cache to store password for ssh
git config --global credential.helper 'cache --timeout=9999999999999999999'

# Load Helpers
# Function to load .sh files from given directories
function load_sh_files() {
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

export HISTCONTROL=ignoredups # don't put duplicate lines in the history.

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
  #docker
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
tmux_setup

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Locate the highest Python version in the Library and add it to the PATH
  highest_python_bin=$(find $HOME/Library/Python -type d -name 'bin' | sort -V | tail -1)
  if [ -d "$highest_python_bin" ]; then
    # echo "Python $highest_python_bin bin found"
    pathmunge "$highest_python_bin"
  fi
fi

# if [ -d "/opt/homebrew/bin" ]; then
#   pathmunge /opt/homebrew/bin

#   eval "$(/opt/homebrew/bin/brew shellenv)"
# fi

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

#dotnet core #opt-out of telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Add to .zshrc
# Source global definitions
# if [ -f $HELPER_DOTFILES_HOME/zsh/myzshrc.sh ]; then
#    echo "Loading My Scripts"
#    . $HELPER_DOTFILES_HOME/zsh/myzshrc.sh
# fi

# Powerline configuration
if [ -f /usr/share/powerline/bindings/zsh/powerline.zsh ]; then
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
      #echo "Sourcing Powerline from: $newest_powerline"
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

# fzf TODO: move to a seperate file
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"

  # --- setup fzf theme ---
  fg="#CBE0F0"
  bg="#011628"
  bg_highlight="#143652"
  purple="#B388FF"
  blue="#06BCE4"
  cyan="#2CF9ED"

  export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

  # play with first but maybe add --strip-cwd-prefix (exclude the current working directory from the search results)
  #export FZF_DEFAULT_COMMAND='fd --files --no-ignore --hidden --follow --glob "!.git/*"'
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --follow --exclude '.git'"

  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }

  _fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
  }

  source ~/Projects/src/github.com/junegunn/fzf-git.sh/fzf-git.sh
  #source ~/Projects/src/github.com/junegunn/fzf/bin/fzf-tmux

  export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

  _fzf_comprun() {
    local command=$1
    shift

    case "$command" in
    cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export | unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
    ssh) fzf --preview 'dig {}' "$@" ;;
    *) fzf --preview "bat -n --color=always --line-range :500 {}" "$@" ;;
    esac
  }

  # ----- Bat (better cat) -----

  export BAT_THEME=Dracula
  # todo, create a loader that checks/updates https://github.com/catppuccin/bat

  # ---- Eza (better ls) -----

  #alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
  alias ls="eza --color=always --icons=always"

fi

if command -v zoxide >/dev/null 2>&1; then
  # echo "zoxide found"
  eval "$(zoxide init zsh)"
  alias cd="zoxide"
fi

# reset the path hash to avoid issues with zsh
hash -r
echo "-------------------------------------"
