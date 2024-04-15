# tmux.sh

tmux_disconnect() {
  tmux detach
}

function tmux_restore() {
  if which tmux >/dev/null 2>&1; then
    # if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
    if [[ $- =~ i ]] && [[ -z "$TMUX" ]]; then
      tmux attach-session -t $HOST || tmux new-session -s $HOST
    fi
  fi
}

# attach to an existing tmux sessions, if does not exist, cleaning create one
function tmux_default() {
  if [ -z "$TMUX" ]; then
    # base_session=$HOSTNAME
    base_session=$USER
    # Create a new session if it doesn't exist
    tmux has-session -t $base_session || tmux new-session -d -s $base_session
    # Are there any clients connected already?
    client_cnt=$(tmux list-clients | wc -l)
    if [ $client_cnt -ge 1 ]; then
      session_name=$base_session"-"$client_cnt
      tmux new-session -d -t $base_session -s $session_name
      tmux -2 attach-session -t $session_name \; set-option destroy-unattached
    else
      tmux -2 attach-session -t $base_session
    fi
  fi
}

tmux_load_ifier() {
  git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
  export PATH="$HOME/.tmuxifier/bin:$PATH"
}

# tmuxifier allows for template sessions
tmux_setup() {
  if [ -d "$HOME/.tmuxifier/bin" ]; then
    pathmunge $HOME/.tmuxifier/bin
    eval "$(tmuxifier init - zsh)"
  fi
}
