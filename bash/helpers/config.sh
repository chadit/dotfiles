set_neovim() {
  local CURRENTDIR=$(pwd)
  mkdir -p ~/.config/nvim
  ln -s $HOME/Projects/src/github.com/chadit/dotfiles/home/.config/nvim/colors $HOME/.config/nvim/colors
  ln -s $HOME/Projects/src/github.com/chadit/dotfiles/home/.config/nvim/init.lua $HOME/.config/nvim/init.lua
  ln -s $HOME/Projects/src/github.com/chadit/dotfiles/home/.config/nvim/init-vim.vim $HOME/.config/nvim/init-vim.vim
  ln -s $HOME/Projects/src/github.com/chadit/dotfiles/home/.config/nvim/lua $HOME/.config/nvim/lua

  cd $CURRENTDIR
}