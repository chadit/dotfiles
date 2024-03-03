
local function ruby_install_rbenv() {
  # Get the rbenv root directory
  if [ ! -d "$HOME/.rbenv/bin" ]; then
    #echo "rbenv found."
  #else
    local CURRENTDIR=$(pwd)
    echo "rbenv not found. Installing rbenv..."
    # Install rbenv (adjust the installation method if necessary)
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    cd ~/.rbenv && src/configure && make -C src
    cd $CURRENTDIR
  fi
}

local function ruby_install_build(){
  if [ ! -d "$(rbenv root)"/plugins/ruby-build ]; then
    echo "Installing ruby-build plugin..."
    mkdir -p "$(rbenv root)"/plugins
    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
  fi
}

local function ruby_update_build(){
  if [ -d "$(rbenv root)"/plugins/ruby-build ]; then
    echo "Updating ruby-build plugin..."
    cd "$(rbenv root)"/plugins/ruby-build && git pull
  fi
}

local function ruby_set_latest(){
  if command -v rbenv >/dev/null 2>&1; then
    #latest_ruby=$(rbenv install -l | grep -v - | grep -E "^  [0-9]" | tail -1 | tr -d ' ')
    latest_ruby=$(rbenv install -l | grep -v - | tail -1)

    # Get the currently active Ruby version
    current_ruby=$(rbenv version | cut -d ' ' -f 1)
    echo "Latest Ruby version available: $latest_ruby"
    echo "Currently active Ruby version: $current_ruby"

    if [ "$latest_ruby" != "$current_ruby" ]; then
      rbenv install $latest_ruby
      rbenv global $latest_ruby
      rbenv rehash
    fi
  fi
}

local function ruby_install_dependencies(){
  # Install bundler
  if command -v gem >/dev/null 2>&1; then
    gem install bundler seeing_is_believing solargraph rufo htmlbeautifier rbeautify rubocop
  fi
}

function ruby_update() {
  local CURRENTDIR=$(pwd)
  ruby_update_build
  ruby_set_latest

  if command -v gem >/dev/null 2>&1; then
    gem update --system
    gem update
  fi

  cd $CURRENTDIR
}


function ruby_setup() {
  ruby_install_rbenv

  if [ -d "$HOME/.rbenv/shims" ]; then
    pathmunge $HOME/.rbenv/shims
  fi

  if [ -d "$HOME/.rbenv/bin" ]; then
    pathmunge $HOME/.rbenv/bin
    eval "$(rbenv init - zsh)"
    #echo 'eval "$(~/.rbenv/bin/rbenv init - zsh)"' >> ~/.zshrc

    if rbenv -v >/dev/null; then
      rbenv -v
    fi
  fi

  if command -v ruby >/dev/null 2>&1; then
    ruby -v
  fi

  ruby_install_build
}