#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# setup-ubunutu.pre.sh is designed to be run on a fresh install of Ubuntu. 
# It sets up the environment for the rest of the setup.sh script to run. 
# It sets the HELPER_DOTFILES_HOME environment variable, updates /etc/environment and /etc/profile, and updates the .zshrc file. 
# It also installs some basic packages and sets up the go environment.

echo "--------------------------------------------------------------------------------"
echo "- running update to ensure system is up to date                                -"
echo "- if this is a company machine, you may need to be on the VPN for this to work -"
echo "--------------------------------------------------------------------------------"

# Update package lists.
update_output=$(sudo apt update 2>&1)

# Check for success status and specific warning messages in the output
if [ $? -ne 0 ] || echo "$update_output" | grep -q "Failed to fetch"; then
    echo "apt update failed or encountered a problem, exiting script. check network connection and try again."
    exit 1
fi

echo "apt update completed successfully."

# seperate due to if vpn is not connected it fails faster.
sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

echo "apt upgrade completed successfully."

# install basic packages needed for initial setup.
sudo apt install -y git zsh curl wget unzip jq apt-transport-https ca-certificates software-properties-common xclip build-essential libreadline-dev powerline

echo "basic packages installed successfully."

if ! command -v docker &> /dev/null; then
    echo "setup docker"

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    sudo apt-get update

    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose docker-compose-plugin -y

    sudo groupadd docker
    sudo usermod -aG docker $USER

    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service

    sudo systemctl start docker.service
    sudo systemctl start containerd.service

    echo "docker installed successfully."
else
    echo "docker is already installed."
fi



sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "basic packages installed successfully."

# updating max user watches because ubuntu sets it low by default and it causes issues with some tools.

# The configuration line to check for and append if not found

echo "updating max user watches"

CONFIG_LINE="fs.inotify.max_user_watches=524288"

# The file to check in
FILE="/etc/sysctl.conf"

# Check if the line exists in the file
if ! grep -q "^${CONFIG_LINE}$" "$FILE"; then
    echo "Appending $CONFIG_LINE to $FILE"
    echo "$CONFIG_LINE" | sudo tee -a "$FILE" > /dev/null
else
    echo "$CONFIG_LINE already set in $FILE"
fi

# syncthing is used to sync dotfiles between machines and backup to the NAS.

# Check if Syncthing is already installed
if ! command -v syncthing &> /dev/null; then
    echo "Syncthing is not installed. Installing..."

    sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
    echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
    sudo apt install syncthing -y

    SERVICE_FILE="/etc/systemd/system/syncthing@.service"

    if [ ! -f "$SERVICE_FILE" ]; then
    echo "Creating Syncthing systemd service file..."

    # Use sudo to create and edit the service file
    sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Syncthing - Open Source Continuous File Synchronization
Documentation=man:syncthing(1)
After=network.target

[Service]
User=%i
ExecStart=/user/bin/syncthing -no-browser -gui-address="0.0.0.0:8384"  -no-restart -logflags=0
Restart=on-failure
RestartSec=5
SuccessExitStatus=3 4
RestartForceExitStatus=3 4

[Install]
WantedBy=multi-user.target
EOF

    echo "Syncthing systemd service file created."

    sudo systemctl start syncthing@$USER
    sudo systemctl enable syncthing@$USER

    echo "Syncthing installed successfully."
else
    echo "Syncthing is already installed."
fi


echo "---------------------------------------------------------------------------------"
echo "- pre setup completed.  manually finish setting up syncthing and start setup.sh -"
echo "---------------------------------------------------------------------------------"