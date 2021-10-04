# User specific aliases and functions
if [ -d "/home/chadit/Projects/src/github.com" ]; then
	alias gh='cd /home/chadit/Projects/src/github.com/'
else
	alias gh='cd $HOME/Projects/src/github.com/'
fi

if [ -d "/home/chadit/Projects/src/github.com/chadit/dotfiles/install" ]; then
	alias is='cd /home/chadit/Projects/src/github.com/chadit/dotfiles/install/'
else
	alias is='cd /Users/chadit/Projects/src/github.com/chadit/dotfiles/install/'
fi

alias cls=reset_terminal1

alias vim="nvim"
alias oldvim="\vim"