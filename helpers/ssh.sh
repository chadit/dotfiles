#!/bin/zsh

function ssh_fix_permissions() {
  # Directory containing SSH keys
  SSH_DIR="$HOME/.ssh"

  eval $(ssh-agent -s) >/dev/null 2>&1
  #ssh-add

  if [ -d "$HOME/.ssh" ]; then
    chmod 700 ~/.ssh
  fi

  if test -f "$HOME/.ssh/authorized_keys"; then
    chmod 644 ~/.ssh/authorized_keys
  fi

  # Fix file permissions
  # Private keys: chmod 600
  # Public keys: chmod 644
  #echo "Fixing permissions for SSH keys..."
  find "$SSH_DIR" -type f -name 'id_*' ! -name '*.pub' -exec chmod 600 {} \;
  find "$SSH_DIR" -type f -name 'id_*.pub' -exec chmod 644 {} \;
}

function ssh_setup() {
  ssh_fix_permissions

  # Directory containing SSH keys
  SSH_DIR="$HOME/.ssh"

  # Add private keys to ssh-agent
  #echo "Adding private keys to ssh-agent..."
  find "$SSH_DIR" -type f -name 'id_*' ! -name '*.pub' -exec ssh-add {} \; >/dev/null 2>&1
  find "$SSH_DIR" -type f -name '*-rsa-*' ! -name '*.pub' -exec ssh-add {} \; >/dev/null 2>&1
}
