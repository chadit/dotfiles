#!/bin/zsh

# system-timer.sh : used by systemd timers to update specific git repos.

source $HELPER_DOTFILES_HOME/helpers/system.sh

system_update
system_cleanup