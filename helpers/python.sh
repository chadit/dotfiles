python_tools_install() {
  # ignore if this is arch linux

  if [ -f /etc/os-release ]; then
    if grep -q 'ID=arch' /etc/os-release; then
      echo "Arch Linux detected. skipping python tools install"
    else
      local tools=(
        "cmakelang"
        "gitlint"
        "pre-commit"
      )

      for tool in "${tools[@]}"; do
        eval pip install $tool
      done
    fi
  fi
}

python_list_tools() {
  pip list
}
