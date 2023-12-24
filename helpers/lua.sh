


function lua_setup(){
  # if luaver is installed, initialize it.
  if test -d "$HOME/.luaver"; then
    echo "luaver"
    . ~/.luaver/luaver
  fi

  if command -v lua >/dev/null 2>&1; then
    lua_version=$(lua -v 2>&1 | awk '{print $2}')
    echo "Lua: $lua_version"
  fi

  if command -v luarocks >/dev/null 2>&1; then
    # find the version of lua rocks and use that.
    zsh_lua_home=$(find $HOME/.luarocks/lib/luarocks -type d -name 'rocks-*' | sort -V | tail -1)
    if [ -d "$zsh_lua_home" ]; then
      luarocks_version=$(luarocks --version | grep -oP 'luarocks \K[0-9]+\.[0-9]+\.[0-9]+')
      echo "LuaRocks: $luarocks_version"

      # Recursively find all 'bin' folders in the directory
      find "$zsh_lua_home" -type d -name 'bin' | while read -r bin; do
        pathmunge "$bin"
      done
    fi
  fi
}