#!/usr/bin/env zsh
# system.sh : commands to help with system operations.

# Function to check if a command exists
local function system_command_exists() {
    command -v "$1" &> /dev/null
}

# Function to source a file from two directories up
local function source_helper() {
    # Construct the path of the file to source
    echo "helper dotfiles home: $HELPER_DOTFILES_HOME"
    local file_to_source="${HELPER_DOTFILES_HOME}helpers/$1"
    echo "File to source: $file_to_source"

    # Check if the file exists and source it
    if [[ -f "$file_to_source" ]]; then
        echo "Sourcing file: $file_to_source"
        source "$file_to_source"
    else
        echo "File to source not found: $file_to_source"
    fi
}

# removes sync conflicts that can happen from syncthing or pcloud
function system_remove_sync_conflicts() {
    # Function to find and remove files matching certain patterns
    cleanup_files() {
        local dir_path=$1
        local patterns=("$@")
        for pattern in "${patterns[@]:1}"; do
            echo "Searching in $dir_path for $pattern files..."
            find "$dir_path" -name "$pattern" -exec echo "Removing {}" \; -exec rm -rf {} \;
        done
    }
    
    # Define patterns to search and delete
    patterns=("*.sync-conflict*" "*.syncthing*" "*conflicted*")
    
    # Cleanup in /mnt/c/Projects if it exists
    if [[ -d /mnt/c/Projects ]]; then
        cleanup_files "/mnt/c/Projects" "${patterns[@]}"
    fi
    
    # Cleanup in $HOME/Projects
    cleanup_files "$HOME/Projects" "${patterns[@]}"
}

# system_cleanup : function to clean up system files.
# system cleanup should not assume functions are available as it is also used by systemd.timers,
# which does not load the zsh profile.
function system_cleanup() {
    echo "clearing trash bin."
    # Clear out trash bin
    # ls ~/.local/share/Trash/files/
    if [ -d "$HOME/.local/share/Trash/files" ]; then
        setopt localoptions nonomatch
        rm -rf $HOME/.local/share/Trash/files/*
    fi
    
    echo "clean cache"
    if [ -d "$HOME/.cache" ]; then
        setopt localoptions nonomatch
        rm -rf $HOME/.cache/*
    fi

    echo "clear out journalctl logs"
    journalctl --vacuum-time=1weeks

    # cleanup docker
    if system_command_exists docker; then
        echo "docker is installed. running cleanup"
        source_helper "docker.sh"
        docker_cleanup
    else
        echo "docker is not installed."
    fi

    system_remove_sync_conflicts
}

# system_update : function to update the system based on metrics.
# system system_update should not assume functions are available as it is also used by systemd.timers,
# which does not load the zsh profile.
function system_update() {
    function system_shared_update(){
        echo "update java sdkman"
        source_helper "java.sh"
        java_sdkman_upgrade_latest

        echo "update node"
        source_helper "node.sh"
        node_update

        echo "update flutter"
        source_helper "flutter.sh"
        flutter_upgrade

        echo "update rust"
        source_helper "rust.sh"
        rust_update

        echo "update special repos"
        update_repos
    }

    # update os
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Operating System: macOS"
    # Check if it's a Linux distribution
    elif [[ "$OSTYPE" == "linux"* ]]; then
        echo "Operating System: Linux"

        # --- update linux ---
        if [ -f /etc/os-release ]; then
            if grep -q 'ID=arch' /etc/os-release; then
                echo "Arch Linux detected. updating"
                source_helper "linux-arch.sh"
                arch_update
            elif grep -q 'ID=ubuntu' /etc/os-release; then
                echo "Ubuntu Linux detected. updating"
                source_helper "linux-ubuntu.sh"
                ubuntu_update
            fi

            # -- update vscode for linux via source.
            vscode_update

        else
            echo "os-release not found"
        fi

        # --- update tools ---

        # Check for Snap
        if system_command_exists snap; then
            echo "Snap is installed."
            sudo killall snap-store
            sudo snap refresh
            sudo snap refresh snap-store
        else
            echo "Snap is not installed."
        fi

        # Check for Flatpak
        if system_command_exists flatpak; then
            echo "Flatpak is installed."
            sudo flatpak update
        else
            echo "Flatpak is not installed."
        fi

        # source go helper and update go
        echo "update go"
        source_helper "go.sh"
        go_update_linux
        go_tools_install
        go_clean_mod

        echo "update ruby"
        source_helper "ruby.sh"
        ruby_update

        echo "update kubernetes"
        source_helper "kubernetes.sh"
        kube_install_kubectl

        


    else
        echo "Operating System: Unknown"
    fi

    system_shared_update
}

# system_move_contents : function to move contents from one directory to another.
function system_move_contents() {
    local src="$1"
    local dest="$2"

    # Check if source directory exists
    if [ ! -d "$src" ]; then
        echo "Source directory does not exist: $src"
        return 1
    fi

    # Check if destination directory exists, if not create it
    if [ ! -d "$dest" ]; then
        echo "Destination directory does not exist, creating: $dest"
        mkdir -p "$dest"
    fi

    # Move all contents from source to destination
    mv "$src"/* "$dest"/

    echo "Contents moved from $src to $dest"
}