function flutter_setup() {
  if test -d "$HOME/development/flutter/bin"; then
    pathmunge $HOME/development/flutter/bin

    # Run flutter --version and capture the output
    flutter_version_output=$(flutter --version)

    # Extract the Flutter version and channel
    version_and_channel=$(echo "$flutter_version_output" | grep -oE 'Flutter [0-9]+\.[0-9]+\.[0-9]+ • channel [a-zA-Z]+' | head -1)

    # Check if there's an update available (you may need to modify this check based on how Flutter indicates updates)
    if echo "$flutter_version_output" | grep -q 'update'; then
      version_and_channel="$version_and_channel • update"
    fi

    echo "$version_and_channel"
  else
    echo "flutter not installed, run flutter_install, restart terminal after install completes"
    flutter_install
  fi  
}

function flutter_install(){
  local CURRENTDIR=$(pwd)

  if test -d "$HOME/development/flutter/bin"; then
    echo "flutter already installed"
    flutter upgrade
  else
    echo "install flutter"
    cd ~/Downloads

    git clone --branch stable https://github.com/flutter/flutter.git

    # # Add Flutter to your path (adjust the file according to your shell)
    # echo 'export PATH="$PATH:/opt/flutter/bin"' >> ~/.bashrc
    # source ~/.bashrc

    # # Run Flutter doctor
    # flutter doctor

   fi

    cd $CURRENTDIR
}

function flutter_upgrade() {
  if command -v flutter >/dev/null 2>&1; then
    flutter upgrade
  else
    flutter_install
  fi
}