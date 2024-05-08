python_tools_install() {
  # ignore if this is arch linux

  if [ -f /etc/os-release ]; then
    if grep -q 'ID=arch' /etc/os-release; then
      # arch has a strange way of handling python, it attempts to force
      # virtualenvs to be used, which is not always the case that is needed
      # so tools that are wanted for the global scope need to be installed
      # via pacman.
      echo "Arch Linux detected. installing pacman variants."
      local tools=(
        "cmake"
        "python-cmake-build-extension"
        # "gitlint"
        "python-gitpython"
        # "powerline"
        "pre-commit"
        "python-pylint"
        "python-pylint-venv"
        "python-pytest"
        "python-pytest-isort"
        "python-pytest-pylint"
        "yq"
        "python-black"
        "mypy"
        "flake8"
        "bandit"
        "python-isort"
      )

      for tool in "${tools[@]}"; do
        eval yes | sudo pacman -Syy $tool
      done

    else
      local tools=(
        "cmakelang"
        "gitlint"
        "gitpython"
        "powerline-status"
        "pre-commit"
        "pylint"
        "pytest"
        "yq"
        "black"
        "mypy"
        "flake8"
        "bandit"
        "isort"
      )

      for tool in "${tools[@]}"; do
        eval pip install --upgrade $tool
      done
    fi
  fi
}

python_list_tools() {
  pip list
}
