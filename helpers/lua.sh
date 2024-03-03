
fuction lua_install() {
    local CURRENTDIR=$(pwd)

    # change directory to tmp
    cd /tmp/

    # https://www.lua.org/ftp/lua-5.4.4.tar.gz

    curl -R -O https://www.lua.org/ftp/lua-5.4.6.tar.gz  # Replace with the latest version
    tar -zxf lua-5.4.6.tar.gz
    cd /tmp/lua-5.4.6
    sudo make linux test  # use 'macosx' instead of 'linux' if on macOS
    sudo make install

    cd /tmp/

    # https://luarocks.github.io/luarocks/releases/luarocks-3.10.0.tar.gz
    # wget https://luarocks.org/releases/luarocks-3.10.0.tar.gz
    curl -R -O https://luarocks.github.io/luarocks/releases/luarocks-3.9.2.tar.gz

    tar -zxf /tmp/luarocks-3.9.2.tar.gz
    cd /tmp/luarocks-3.9.2
  
    ./configure --with-lua-include=/usr/local/include
    make
    sudo make install

    cd $CURRENTDIR

    rm -rf /tmp/lua-*
    rm -rf /tmp/luarocks-*
}

fuction lua_install_luarocks() {
    local CURRENTDIR=$(pwd)

    # change directory to tmp
    cd /tmp/

    # https://luarocks.github.io/luarocks/releases/luarocks-3.10.0.tar.gz
    # wget https://luarocks.org/releases/luarocks-3.10.0.tar.gz
    curl -R -O https://luarocks.github.io/luarocks/releases/luarocks-3.9.2.tar.gz

    tar -zxf /tmp/luarocks-3.9.2.tar.gz
    cd /tmp/luarocks-3.9.2
  
    ./configure --lua-version=5.4 --versioned-rocks-dir
    make
    sudo make install

    cd $CURRENTDIR

    rm -rf /tmp/lua-*
    rm -rf /tmp/luarocks-*
}

function lua_install_dependencies() {
    sudo luarocks install argparse
    sudo luarocks install luacheck
    sudo luarocks install luaformatter
    sudo luarocks install luapretty
    sudo luarocks install luacheck
}


function lua_setup(){
  if command -v lua >/dev/null 2>&1; then
    lua_version=$(lua -v 2>&1 | awk '{print $2}')
    echo "Lua: $lua_version"
  fi

  if command -v luarocks >/dev/null 2>&1; then
    # find the version of lua rocks and use that.
   # zsh_lua_home=$(find $HOME/.luarocks/lib/luarocks -type d -name 'rocks-*' | sort -V | tail -1)
    #if [ -d "$zsh_lua_home" ]; then
      luarocks_version=$(luarocks --version | grep -oP 'luarocks \K[0-9]+\.[0-9]+\.[0-9]+')
      echo "LuaRocks: $luarocks_version"

    if [ -d "$HOME/.luarocks" ]; then
      zsh_lua_home=$(find $HOME/.luarocks/lib/luarocks -type d -name 'rocks-*' | sort -V | tail -1)
      if [ -d "$zsh_lua_home" ]; then
        # Recursively find all 'bin' folders in the directory
        find "$zsh_lua_home" -type d -name 'bin' | while read -r bin; do
          pathmunge "$bin"
        done
      fi
    fi
  fi
}