# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/chadit/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit
# End of lines added by compinstall

fpath=(~/.zsh/completion $fpath)

echo "welcome $(whoami) - Loading My zsh Scripts" 
# Load Helpers
for f in /home/chadit/Projects/src/github.com/chadit/dotfiles/bash/helpers/*.sh; do
  echo -n ".."
 # echo $f  
   . $f
done

setopt completealiases
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY 
setopt CORRECT_ALL
setopt SH_WORD_SPLIT
setopt IGNORE_EOF
setopt NO_BEEP
setopt extended_glob
setopt correct
setopt MENUCOMPLETE
setopt nohup
setopt ZLE
setopt MULTIBYTE
setopt NUMERIC_GLOB_SORT
setopt APPEND_HISTORY
setopt HIST_REDUCE_BLANKS

bindkey "^[[3~" delete-char
bindkey "^[[H"  beginning-of-line
bindkey "^[[F"  end-of-line

# Source ZSH modules
# https://github.com/olivierverdier/zsh-git-prompt
source $HOME/.zsh/plugins/zsh-git-prompt/zshrc.sh 
# https://github.com/zsh-users/zsh-autosuggestions
source $HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 

# ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{≡%G%} "
ZSH_THEME_GIT_PROMPT_CHANGED=" %{$fg[yellow]%}%{✚%G%} "

# Set the prompt.
PROMPT='%n@%M%~$(git_super_status) '

# initalize helpers and variables
init_golang

# added bin for yarn npm applications
pathmunge /home/chadit/.yarn/bin after

# add pip location to path
pathmunge /home/chadit/.local.bin after

# Cargo for Rust
pathmunge $HOME/.cargo/bin after

# Set Vim as default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# Ruby Gem
mkdir -p /home/chadit/gems
export GEM_HOME=/home/chadit/gems

#dotnet core #opt-out of telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

if [ ! -d $BASHPRIVATE ]; then
    echo "private repo not set"
fi

# Load scripts from private repo, $BASHPRIVATE is a private Variable set in /etc/profile
for f in $BASHPRIVATE/*.sh; do
  echo -n ".."
 # echo $f  
   . $f
done

echo ""

# start TMUX
#tmux_default


# Add to .zshrc
# Source global definitions
# if [ -f /home/chadit/Projects/helpers/myzshrc.sh ]; then
#    echo "Loading My Scripts"
#    . /home/chadit/Projects/helpers/myzshrc.sh
# fi