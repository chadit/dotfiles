#!/bin/bash
echo "1"

function set_script_home() {
    # this assumes the repo is already cloned to ~/Projects/src/github.com/chadit/dotfiles
    local logged_in_user_name=$(who | awk '{print $1}' | sort | uniq | grep -v root | head -n 1)
    USER_HOME="/home/${logged_in_user_name}"
    # check if running on macos
    if [ -d "/Users/${logged_in_user_name}" ]; then
        USER_HOME="/Users/${logged_in_user_name}"
    fi

    if [ ! -d "$USER_HOME/Projects/src/github.com/chadit/dotfiles" ]; then
        echo "dotfiles repo not found at $USER_HOME/Projects/src/github.com/chadit/dotfiles"
        exit 1
    fi

    echo "dotfiles repo found at $USER_HOME/Projects/src/github.com/chadit/dotfiles"
}

# Function to add or update HELPER_DOTFILES_HOME in /etc/environment
function update_environment_file() {
    # change if installed somewhere else.
    local helper_dotfiles_home="HELPER_DOTFILES_HOME=${USER_HOME}/Projects/src/github.com/chadit/dotfiles/"
    echo "HELPER_DOTFILES_HOME: ${helper_dotfiles_home}"

    local env_config_file="/etc/environment"
    local profile_config_file="/etc/profile"

    if ! grep -q "^${helper_dotfiles_home}$" "$env_config_file"; then
        echo "Appending $helper_dotfiles_home to $env_config_file"
        echo "$helper_dotfiles_home" | sudo tee -a "$env_config_file" > /dev/null
    else
        echo "$helper_dotfiles_home already set in $env_config_file"
    fi

    if ! grep -q "^${helper_dotfiles_home}$" "$profile_config_file"; then
        echo "Appending $helper_dotfiles_home to $profile_config_file"
        echo "$helper_dotfiles_home" | sudo tee -a "$profile_config_file" > /dev/null
    else
        echo "$helper_dotfiles_home already set in $profile_config_file"
    fi
}

function update_zshrc() {
    echo "Updating .zshrc"
    # I run my own custom .zshrc file that is part of my repo.
    local zshrc_location="${USER_HOME}/.zshrc"
    rm -f ${zshrc_location}

cat <<EOF > ${zshrc_location}
source /etc/profile

# Add to .zshrc
# Source global definitions
if [ -f \$HELPER_DOTFILES_HOME/zsh/myzshrc.sh ]; then
    echo "Loading My Scripts"
    . \$HELPER_DOTFILES_HOME/zsh/myzshrc.sh
fi
EOF
}

function update_link_nvim(){
    mkdir -p ~/.config/nvim
    ln -sf $HELPER_DOTFILES_HOME/config/nvim $HOME/.config/nvim
}

function update_link_tmux(){
    # link the custom tmux.config to the system
    ln -sf $HELPER_DOTFILES_HOME/tmux/tmux.conf $HOME/.tmux.conf

    if [ ! -d $HOME/.tmux/plugins/tpm ]; then
        # install the tmux plugin manager
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
}

function update_learning_links(){
    ln -sf ${USER_HOME}/Projects/src/github.com/chadit/CodeChallenges/exercism ~/exercism

    ln -sf $HELPER_DOTFILES_HOME/alacritty/alacritty.toml ~/.alacritty.toml
}

# This script must be run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

set_script_home
update_environment_file
update_zshrc
update_link_nvim
update_link_tmux
update_learning_links


# TODO:
# add the ripgrep based on linux and mac, this is needed for telescop search.
