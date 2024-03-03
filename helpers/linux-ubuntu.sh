

function ubuntu_update() {
  # Update package lists.
  update_output=$(sudo apt update 2>&1)

  # Check for success status and specific warning messages in the output
  if [ $? -ne 0 ] || echo "$update_output" | grep -q "Failed to fetch"; then
      echo "apt update failed or encountered a problem, exiting script. check network connection and try again."
      exit 1
  fi

  echo "apt update completed successfully."

  # seperate due to if vpn is not connected it fails faster.
  sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

  echo "apt upgrade completed successfully."
}

# using the above function, catches network connections that have packages stored on a network location that needs a vpn to access.
# function ubuntu_update() {
#   sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo apt autoremove && sudo apt autoclean
# }