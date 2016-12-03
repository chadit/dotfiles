# vscode

# todo add a check for version
sudo eopkg rm vscode

cd /home/chadit/Downloads/

VSCODEVER=code-stable-code_1.7.2-1479766213_amd64.tar.gz

# Download the sources if file does not exist
if [ ! -f /home/chadit/Downloads/${VSCODEVER} ]; then
    sudo wget https://az764295.vo.msecnd.net/stable/7ba55c5860b152d999dda59393ca3ebeb1b5c85f/${VSCODEVER}
fi

sudo tar -xvf ${VSCODEVER}

# make sure the go folder is created
sudo mkdir -p /usr/share/code

# Install to /usr/local/bin
sudo rsync -av VSCode-linux-x64/ /usr/share/code

VSCODESHORTCUT="[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=/usr/share/code/code %U
Icon=code
Type=Application
StartupNotify=true
StartupWMClass=Code
Categories=Utility;TextEditor;Development;IDE;
MimeType=text/plain;
Actions=new-window;
Keywords=vscode;"

sudo touch /usr/share/applications/code.desktop
sudo chown chadit /usr/share/applications/code.desktop
sudo echo "${VSCODESHORTCUT}" > /usr/share/applications/code.desktop

sudo rm -rf vscode*
sudo rm -rf VSCode*
sudo rm -rf code-stable*



