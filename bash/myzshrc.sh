# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

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
HISTSIZE=5000
SAVEHIST=1000
##bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
##zstyle :compinstall filename '/home/chadit/.zshrc'

##autoload -Uz compinit promptinit
##compinit
##promptinit
# End of lines added by compinstall

fpath=(~/.zsh/completion $fpath)

echo "g-welcome $(whoami) - Loading My zsh Scripts"

# if ! command -v rbenv &>/dev/null; then
#   echo rbenv -v
# fi

if rbenv -v >/dev/null; then
  rbenv -v
fi

# Load Helpers
FILE=$HOME/Projects/src/github.com/chadit/dotfiles/bash/helpers
if [ -d "$FILE" ]; then
  for f in $FILE/*.sh; do
    echo -n ".."
    # echo $f
    . $f
  done
fi

# hoping this removes the history on reload
unsetopt share_history
##setopt completealiases
##setopt HIST_IGNORE_SPACE
##setopt INC_APPEND_HISTORY
##setopt EXTENDED_HISTORY
##setopt CORRECT_ALL
##setopt SH_WORD_SPLIT
##setopt IGNORE_EOF
##setopt NO_BEEP
##setopt extended_glob
##setopt correct
##setopt MENUCOMPLETE
##setopt nohup
##setopt ZLE
##setopt MULTIBYTE
##setopt NUMERIC_GLOB_SORT
##setopt APPEND_HISTORY
##setopt HIST_REDUCE_BLANKS

##bindkey "^[[3~" delete-char
##bindkey "^[[H"  beginning-of-line
##bindkey "^[[F"  end-of-line

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
)

ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh

# Source ZSH modules
# https://github.com/olivierverdier/zsh-git-prompt
#source $HOME/.zsh/plugins/zsh-git-prompt/zshrc.sh
# https://github.com/zsh-users/zsh-autosuggestions
#source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# https://github.com/1995parham/buffalo.zsh
#source $HOME/.zsh/plugins/buffalo.zsh

# ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[cyan]%}"
##ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{≡%G%} "
##ZSH_THEME_GIT_PROMPT_CHANGED=" %{$fg[yellow]%}%{✚%G%} "

##GIT_PROMPT_EXECUTABLE="haskell"
# Set the prompt.
#PROMPT='%n@%M%~$(RPROMPT) '
#PROMPT='%B%m%~%b$(git_super_status) %# '
# ---PROMPT='%B%m%~%b%# '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}*"

#alias vim=nvim

#ZSH_THEME_GIT_PROMPT_PREFIX="$fg[white]($fg[red]"
#ZSH_THEME_GIT_PROMPT_SUFFIX="$fg[white])"
#ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green] *"
#ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red] *"

#function git_prompt_info() {
#ref=$(git symbolic-ref HEAD 2> /dev/null) || return
#echo $(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX
#}

#local local_git_prompt='$(git_prompt_info)'

#export PROMPT='%B%m%~%b${git_super_status} %# '

#export RPROMPT="%{$fg[white]%}(%{$fg[green]%}%T%{$fg[white]%})%{$reset_color%}"
#export PROMPT=" %{$terminfo[bold]$fg[green]%}%n$fg[white]@$fg[white]%m%{$reset_color%}%{$terminfo[bold]$fg[blue]%} $fg[white][$fg[blue]%~$fg[white]] ${local_git_prompt}%{$reset_color%}
#%B%{$fg[blue]%}--%{$fg[green]%}> %b%{$reset_color%}"

#export PROMPT=" %{$terminfo[bold]$fg[green]%}%n$fg[white]@$fg[white]%m%{$reset_color%}%{$terminfo[bold]$fg[blue]%} $fg[white][$fg[blue]%~$fg[white]]$(git_prompt_info)%{$reset_color%}%B%{$fg[blue]%}:%{$fg[green]%}%b%{$reset_color%}"

function prompt_char {
  git branch >/dev/null 2>/dev/null && echo '±' && return
  hg root >/dev/null 2>/dev/null && echo '☿' && return
  echo '○'
}

export PROMPT='%n@%m[%~]:$(git_prompt_info)$(prompt_char)%{$reset_color%} '

RPROMPT=""

#PROMPT="$PROMPT"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

if [ -d "$HOME/.goenv/bin" ]; then
  pathmunge $HOME/.goenv/bin
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
fi

if [ -d "$HOME/.luarocks/lib/luarocks/rocks-5.3/luaformatter/scm-1/bin" ]; then
  pathmunge $HOME/.luarocks/lib/luarocks/rocks-5.3/luaformatter/scm-1/bin
fi

# initalize helpers and variables
init_golang

export GITHUB_TOKEN=ad13cc0ddbd2a33a8a6e9d1c64c20261c0c3fd31

# added bin for yarn npm applications
pathmunge $HOME/.yarn/bin after

# add pip location to path
pathmunge $HOME/.local.bin after

# Cargo for Rust
pathmunge $HOME/.cargo/bin after

#python
pathmunge $HOME/Library/Python/3.7/bin

#pathmunge $HOME/.local/bin

pathmunge $HOME/.zsh/plugins/zsh-git-prompt/src/.bin

pathmunge "/usr/local/bin" after

pathmunge $HOME/.npm-global/bin after

pathmunge $HOME/.local/bin after

pathmunge $HOME/.local/share/nvim/site/pack/packer/start after

# Set Vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# Ruby Gem
mkdir -p $HOME/gems
export GEM_HOME=$HOME/gems

#dotnet core #opt-out of telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

echo "Loading keychain"
keychain --clear
# keychain fun
if test -f "$HOME/.ssh/id_rsa"; then
  eval $(keychain --eval --agents ssh id_rsa)
fi

if test -f "$HOME/.ssh/id_rsa_nil"; then
  eval $(keychain --eval --agents ssh id_rsa_nil)
fi

if test -f "$HOME/.ssh/ids_id_rsa"; then
  eval $(keychain --eval --agents ssh ids_id_rsa)
fi

if test -f "$HOME/.ssh/id_cfa_sso"; then
  eval $(keychain --eval --agents ssh $HOME/.ssh/id_cfa_sso)
fi

if test -f "$HOME/.ssh/id_ed25519"; then
  eval $(keychain --eval --agents ssh $HOME/.ssh/id_ed25519.pub)
fi

#cd $HOME

#if [ ! -d $BASHPRIVATE ]; then
#    echo "private repo not set"
#fi

# Load scripts from private repo, $BASHPRIVATE is a private Variable set in /etc/profile
#for f in $BASHPRIVATE/*.sh; do
#  echo -n ".."
# echo $f
# . $f
#done

#echo ""

# start TMUX
#tmux_default

# Add to .zshrc
# Source global definitions
# if [ -f $HOME/Projects/src/github.com/chadit/dotfiles/bash/myzshrc.sh ]; then
#    echo "Loading My Scripts"
#    . $HOME/Projects/src/github.com/chadit/dotfiles/bash/myzshrc.sh
# fi
