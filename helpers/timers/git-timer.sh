#!/bin/bash

echo "Updating git repos"
# git-timer.sh : used by systemd timers to update specific git repos.

source $HELPER_DOTFILES_HOME/helpers/git.sh

git_update_dependancy_repos