# User specific aliases and functions
if [ -d "$HOME/Projects/src/github.com" ]; then
	alias gh='cd $HOME/Projects/src/github.com/'
fi

alias cls=reset_terminal1

alias vim="nvim"
alias oldvim="\vim"

alias exit_session="tmux detach -P"

alias gpull="git pull -f && git prune && git gc --aggressive"