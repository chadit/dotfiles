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
    # local logged_in_user=$(who | awk '{print $1}' | sort | uniq | grep -v root | head -n 1)
    # change if installed somewhere else.
    local helper_dotfiles_home="HELPER_DOTFILES_HOME=${USER_HOME}/Projects/src/github.com/chadit/dotfiles/"
    echo "HELPER_DOTFILES_HOME: ${helper_dotfiles_home}"

    # Check if HELPER_DOTFILES_HOME already exists in /etc/environment
    if grep -q "^HELPER_DOTFILES_HOME=" /etc/environment; then
        echo "HELPER_DOTFILES_HOME already exists in /etc/environment."
    else
        # Add HELPER_DOTFILES_HOME to /etc/environment
        echo "Adding HELPER_DOTFILES_HOME to /etc/environment."
        echo "${helper_dotfiles_home}" >> /etc/environment
    fi

    # Check if HELPER_DOTFILES_HOME already exists in /etc/profile
    if grep -q "^HELPER_DOTFILES_HOME=" /etc/profile; then
        echo "HELPER_DOTFILES_HOME already exists in /etc/profile."
    else
        # Add HELPER_DOTFILES_HOME to /etc/profile
        echo "Adding HELPER_DOTFILES_HOME to /etc/profile."
        echo "export ${helper_dotfiles_home}" >> /etc/profile
    fi
}

function update_zshrc() {
    # local logged_in_user=$(who | awk '{print $1}' | sort | uniq | grep -v root | head -n 1)

    local zshrc_location="${USER_HOME}/.zshrc"
    # if [ -f "/Users/${logged_in_user}/.zshrc" ]; then
    #     zshrc_location="/Users/${logged_in_user}/.zshrc"
    # fi

    search_line="if [ -f \$HELPER_DOTFILES_HOME/zsh/myzshrc.sh ]; then"

    if grep -Fxq "$search_line" ${zshrc_location} ; then
        echo "HELPER_DOTFILES_HOME/zsh/myzshrc.sh already exists in ${zshrc_location}."
    else
        echo "Adding HELPER_DOTFILES_HOME/zsh/myzshrc.sh to ${zshrc_location}."

        content_to_add="# Add to .zshrc\n# Source global definitions\n$search_line\n    echo \"Loading My Scripts\"\n    . \$HELPER_DOTFILES_HOME/zsh/myzshrc.sh\nfi"
        echo -e "$content_to_add" >> ${zshrc_location}
    fi

    ln -sf $HELPER_DOTFILES_HOME/alacritty/alacritty.toml ~/.alacritty.toml
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


# TODO:
# add the ripgrep based on linux and mac, this is needed for telescop search.
