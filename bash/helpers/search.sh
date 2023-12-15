# 
function subfolder_size() {
  local folder_path="$1"
  local folder_limit="$2"


  echo "getting folder size for $folder_path"

  if [ -z "$folder_limit" ]
  then
    folder_limit=10
  fi

  sudo du -ch $folder_path | sort -rh | head -n $folder_limit
}