# f my life if this loads, it means I have to use a mac for something
# I'm sorry, I'm so sorry

_module_brew_install() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

_module_brew_source() {
  pathmunge /opt/homebrew/bin
  eval "$(/opt/homebrew/bin/brew shellenv)"

  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
}

_module_brew_init() {

  if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is installed."
    brew --version

    _module_brew_source
  fi

}

_module_brew_init
