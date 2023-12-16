# linux-arch.sh : commands to help with arch linux

arch_list_aur_packages() {
  # List all AUR packages
  pacman -Qm
}

arch_list_desktop_environment(){
  # Check for desktop environment using environment variable
  if [ "$XDG_CURRENT_DESKTOP" ]; then
      echo "Desktop Environment: $XDG_CURRENT_DESKTOP"
  else
      # Fallback method by checking for specific processes
      if pgrep -l "gnome-session" > /dev/null; then
          echo "Desktop Environment: GNOME"
      elif pgrep -l "xfce4-session" > /dev/null; then
          echo "Desktop Environment: XFCE"
      elif pgrep -l "plasma" > /dev/null; then
          echo "Desktop Environment: KDE Plasma"
      # Add more elif statements for other desktop environments as needed
      else
          echo "Desktop Environment: Unknown"
      fi
  fi
}

arch_backup_packages() {
  local save_dir="$HELPER_DOTFILES_HOME/backup/arch"
  mkdir -p "$save_dir"

  local hostname1=$(uname -n)
  # Filename for the package list, including the hostname
  local backup_file="${save_dir}/${hostname1}_arch_packages_backup.txt"

  # Get the list of explicitly installed packages (excluding dependencies)
  pacman -Qqe > "$backup_file"

  echo "Package list saved to $backup_file"
}

arch_update() {
  # update arch
  sudo pacman -Syyu --noconfirm

  # TODO: once a week clear the cache, warning this prevents rollbacks
  sudo pacman -Scc --noconfirm

  # remove unused packages
  # Get the list of orphaned packages
  orphans=$(pacman -Qtdq)

  # Check if there are any orphaned packages
  if [ -z "$orphans" ]; then
      echo "No orphaned packages to remove."
  else
      # Remove orphaned packages
      sudo pacman -Rns $orphans --noconfirm
  fi
}

arch_setup_aur() {
  # install yay
  if ! command -v yay &> /dev/null; then
    local CURRENTDIR=$(pwd)
    echo "yay not found. installing"
    cd ~

    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

    cd $CURRENTDIR
  else
    echo "yay is installed"
  fi
}