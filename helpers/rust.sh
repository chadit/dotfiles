
rust_update() {
  if command -v rustc >/dev/null 2>&1; then
    echo "Rust is already installed."
    # Update Rust
    rustup update
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