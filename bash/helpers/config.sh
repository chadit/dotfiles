set_neovim() {
  local CURRENTDIR=$(pwd)
  mkdir -p ~/.config/nvim
  ln -s $HELPER_DOTFILES_HOME/home/.config/nvim/colors $HOME/.config/nvim/colors
  ln -s $HELPER_DOTFILES_HOME/home/.config/nvim/init.lua $HOME/.config/nvim/init.lua
  ln -s $HELPER_DOTFILES_HOME/home/.config/nvim/init-vim.vim $HOME/.config/nvim/init-vim.vim
  ln -s $HELPER_DOTFILES_HOME/home/.config/nvim/lua $HOME/.config/nvim/lua

  cd $CURRENTDIR
}