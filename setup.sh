#!/bin/bash

# this assumes the repo is already cloned to ~/Projects/src/github.com/chadit/dotfiles

# Function to get the primary logged-in user
function get_logged_in_user() {
    # Assuming the first non-root user is the primary user
    who | awk '{print $1}' | sort | uniq | grep -v root | head -n 1
}

# Function to add or update HELPER_DOTFILES_HOME in /etc/environment
function update_environment_file() {
    local logged_in_user=$(get_logged_in_user)
    # change if installed somewhere else.
    local helper_dotfiles_home="HELPER_DOTFILES_HOME=/home/${logged_in_user}/Projects/src/github.com/chadit/dotfiles/"
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
    local logged_in_user=$(get_logged_in_user)

    search_line="if [ -f \$HELPER_DOTFILES_HOME/zsh/myzshrc.sh ]; then"

    if grep -Fxq "$search_line" /home/${logged_in_user}/.zshrc; then
        echo "HELPER_DOTFILES_HOME/zsh/myzshrc.sh already exists in /home/${logged_in_user}/.zshrc."
    else
        echo "Adding HELPER_DOTFILES_HOME/zsh/myzshrc.sh to /home/${logged_in_user}/.zshrc."
        
        content_to_add="# Add to .zshrc\n# Source global definitions\n$search_line\n    echo \"Loading My Scripts\"\n    . \$HELPER_DOTFILES_HOME/zsh/myzshrc.sh\nfi"
        echo -e "$content_to_add" >> /home/${logged_in_user}/.zshrc
    fi
}

# This script must be run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

update_environment_file
update_zshrc
