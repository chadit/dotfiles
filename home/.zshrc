
# Source global definitions
if [ -f $HOME/Projects/src/github.com/chadit/dotfiles/bash/myzshrc.sh ]; then
    . $HOME/Projects/src/github.com/chadit/dotfiles/bash/myzshrc.sh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
alias k=kubectl
complete -F __start_kubectl k

alias luamake=$HOME/.config/nvim/lua-language-server/3rd/luamake/luamake

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin

[ -s ~/.luaver/luaver ] && . ~/.luaver/luaver


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
