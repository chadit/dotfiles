# install flutter


set_flutter_bin() {
  if test -d "$HOME/development/flutter/bin"; then
    echo "flutter bin found"
    pathmunge $HOME/development/flutter/bin
  fi

  echo $(flutter --version)
}