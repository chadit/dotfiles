# tmux.sh

tmux_disconnect() {
  tmux detach
}

tmux_load_ifier() {
  git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
  export PATH="$HOME/.tmuxifier/bin:$PATH"
}

# tmuxifier allows for template sessions
tmux_setup() {
  #   if [ -d "$HOME/.tmuxifier/bin" ]; then
  #     pathmunge $HOME/.tmuxifier/bin
  #     eval "$(tmuxifier init - zsh)"
  #   fi
}
