

terminal_alacritty_setup() {
  local CURRENTDIR=$(pwd)

  if test -d "$HOME/Projects/src/github.com/alacitty/alacritty"; then
    echo "github.com/alacitty/alacritty"
    cd $HOME/Projects/src/github.com/alacitty/alacritty
    git reset --hard && git pull -f && git prune && git gc --aggressive

    # cargo build --release
    # Force support for only Wayland
    cargo build --release --no-default-features --features=wayland

    infocmp alacritty
    sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database
  fi

  cd $CURRENTDIR
}