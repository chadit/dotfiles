set_flutter_bin() {
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
  fi  
}

upgrade_flutter() {
  if test -d "$HOME/development/flutter/bin"; then
    flutter upgrade
  fi
}