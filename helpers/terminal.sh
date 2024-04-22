terminal_alacritty_setup_linux_wayland() {
  local CURRENTDIR=$(pwd)

  if test -d "$HOME/Projects/src/github.com/alacritty/alacritty"; then
    echo "github.com/alacritty/alacritty"
    cd $HOME/Projects/src/github.com/alacritty/alacritty
    git reset --hard && git pull -f && git prune && git gc --aggressive

    # cargo build --release.
    # Force support for only Wayland
    cargo build --release --no-default-features --features=wayland

    infocmp alacritty
    cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty

    sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database

    ln -s $HELPER_DOTFILES_HOME/alacritty/alacritty.toml ~/.alacritty.toml
  fi

  cd $CURRENTDIR
}

terminal_alacritty_setup_linux_x11() {
  local CURRENTDIR=$(pwd)

  if test -d "$HOME/Projects/src/github.com/alacritty/alacritty"; then
    echo "github.com/alacritty/alacritty"
    cd $HOME/Projects/src/github.com/alacritty/alacritty
    git reset --hard && git pull -f && git prune && git gc --aggressive

    # cargo build --release
    # Force support for only x11
    cargo build --release --no-default-features --features=x11

    infocmp alacritty
    cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty

    sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database

    ln -s $HELPER_DOTFILES_HOME/alacritty/alacritty.toml ~/.alacritty.toml
  fi

  cd $CURRENTDIR
}

terminal_alacritty_setup_macos() {
  local CURRENTDIR=$(pwd)

  if test -d "$HOME/Projects/src/github.com/alacritty/alacritty"; then
    echo "github.com/alacritty/alacritty"
    cd $HOME/Projects/src/github.com/alacritty/alacritty
    git reset --hard && git pull -f && git prune && git gc --aggressive

    make app

    cp -r target/release/osx/Alacritty.app /Applications/

    # self sign the app because apple is a pain.
    # Generate a private key
    openssl genrsa -out alacritty.key 2048

    # Create a certificate signing request (CSR)
    openssl req -new -key alacritty.key -out alacritty.csr

    # Generate a self-signed certificate
    openssl x509 -req -days 365 -in alacritty.csr -signkey alacritty.key -out alacritty.crt

    # Import the certificate into the keychain
    security import alacritty.crt -k ~/Library/Keychains/login.keychain

    sudo codesign -fs "Alacritty" /Applications/Alacritty.app

    ln -s $HELPER_DOTFILES_HOME/alacritty/alacritty.toml ~/.alacritty.toml

    infocmp alacritty
  fi

  cd $CURRENTDIR
}
