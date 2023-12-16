
dart_setup() {
  if test -d "$HOME/.pub-cache/bin"; then
    echo "dart bin found"
    pathmunge $HOME/.pub-cache/bin
  fi
}