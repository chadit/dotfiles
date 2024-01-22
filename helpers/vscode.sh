#!/bin/zsh

function vscode_stable() {
  local CURRENTDIR=$(pwd)
  cd $HELPER_DOTFILES_HOME/backup/install

  VSCODE_URL="https://update.code.visualstudio.com/latest/linux-x64/stable"
  INSTALL_DIR="/opt/code"

  # Download the latest version of VSCode
  wget -O vscode-latest.tar.gz "$VSCODE_URL" || curl -L "$VSCODE_URL" -o vscode-latest.tar.gz

  # Extract the tarball to the installation directory
  sudo mkdir -p "$INSTALL_DIR"
  sudo tar -xvzf vscode-latest.tar.gz -C "$INSTALL_DIR" --strip-components=1

  # Remove the tarball
  rm vscode-latest.tar.gz
  if test -f "/usr/share/applications/code.desktop"; then
  else

VSCODESHORTCUT="[Desktop Entry]
Name=Visual Studio Code.
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=/opt/code/code %U
Icon=/opt/code/resources/app/resources/linux/code.png
Type=Application
StartupNotify=true
StartupWMClass=Code
Categories=Utility;TextEditor;Development;IDE;
MimeType=text/plain;
Keywords=vscode;"

    local logged_in_user=$(who | awk '{print $1}' | sort | uniq | grep -v root | head -n 1)
    sudo touch /usr/share/applications/code.desktop
    sudo chown ${logged_in_user} /usr/share/applications/code.desktop
    sudo echo "${VSCODESHORTCUT}" > /usr/share/applications/code.desktop

    sudo update-desktop-database
    # Create a symbolic link (optional)
    # sudo ln -sf "$INSTALL_DIR/code" /usr/local/bin/code
  fi

  echo "VSCode has been updated to the latest version."
  cd $CURRENTDIR
}

function vscode_insider() {
  local CURRENTDIR=$(pwd)
  cd $HELPER_DOTFILES_HOME/backup/install

  VSCODE_URL="https://update.code.visualstudio.com/latest/linux-x64/insider"
  INSTALL_DIR="/opt/vscode"

  # Download the latest version of VSCode
  wget -O vscode-latest.tar.gz "$VSCODE_URL" || curl -L "$VSCODE_URL" -o vscode-latest.tar.gz

  # Extract the tarball to the installation directory
  sudo mkdir -p "$INSTALL_DIR"
  sudo tar -xvzf vscode-latest.tar.gz -C "$INSTALL_DIR" --strip-components=1

  # Remove the tarball
  rm vscode-latest.tar.gz

  if test -f "/usr/share/applications/vscode.desktop"; then
  else

VSCODESHORTCUT="[Desktop Entry]
Name=Visual Studio Code - Insiders.
Comment=Code Editing. Redefined. Insiders.
GenericName=Text Editor
Exec=/opt/vscode/bin/code-insiders %U
Icon=/opt/vscode/resources/app/resources/linux/code.png
Terminal=false
Type=Application
Categories=Utility;TextEditor;Development;IDE;
Keywords=vscodeI;"

    local logged_in_user=$(who | awk '{print $1}' | sort | uniq | grep -v root | head -n 1)
    sudo touch /usr/share/applications/vscode.desktop
    sudo chown ${logged_in_user} /usr/share/applications/vscode.desktop
    sudo echo "${VSCODESHORTCUT}" > /usr/share/applications/vscode.desktop

    sudo update-desktop-database
    # Create a symbolic link (optional)
    sudo ln -sf "$INSTALL_DIR/code" /usr/local/bin/code
  fi

  echo "VSCode has been updated to the insider version."
  cd $CURRENTDIR
}

function vscode_update() {
    vscode_stable
    vscode_insider
}