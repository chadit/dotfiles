rust_update() {
  if command -v rustc >/dev/null 2>&1; then
    echo "Rust is already installed."
    # Update Rust
    # rustup update
    rustup toolchain install nightly
  else
    echo "Installing Rust..."
    # Install Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  fi

}

rust_setup() {
  # Cargo for Rust
  if [ -d $HOME/.cargo/bin ]; then
    pathmunge $HOME/.cargo/bin
    echo $(rustc -V)
    export RUST_BACKTRACE=1
  fi
}

rust_tools_install() {
  local tools=(
    "--branch main --git https://github.com/Kampfkarren/selene selene"
    "git-delta"
    "eza"
    "fd-find"
    "bat"
    "ripgrep"
    "cargo-update" # cargo install-update -a, updates cargo packages that are installed via cargo install.
    "cargo-cache"  # cargo cache -c, clears the cargo cache.
    "tlrc"         # cargo tldr, a tldr client for Rust. example use tldr git
    "zoxide"
  )

  for tool in "${tools[@]}"; do
    # ensure that the tool is installed.
    eval cargo install $tool
  done

  # update installed tools
  cargo install-update -a
  # clear the cache from cargo installs
  cargo cache -a
}

rust_list_tools() {
  cargo install --list
}

function rust_cleanup() {
  local CURRENTDIR=$(pwd)

  cd $HOME/Projects
  # Find all 'Cargo.toml' files in subdirectories and get their directories
  find . -type f -name "Cargo.toml" -print0 | while IFS= read -r -d '' file; do
    # Extract directory path
    dir=$(dirname "$file")
    echo "Cleaning up Rust project in: $dir"
    # Change to the directory and run 'cargo clean'
    (cd "$dir" && cargo clean)
  done

  cd $CURRENTDIR
}
