
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

rust_tools_install(){
  local tools=(
    "--branch main --git https://github.com/Kampfkarren/selene selene"
  )

  for tool in "${tools[@]}"; do
    eval cargo install $tool
  done
}

rust_list_tools(){
  cargo install --list
}