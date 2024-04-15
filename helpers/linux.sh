# linux_top_memory will show the top 10 processes using the most memory
function linux_top_memory() {
  ps -eo pid,comm,%mem --sort=-%mem | head -n 11
}

# linux_top_cpu will show the top 10 processes using the most CPU
function linux_top_cpu() {
  ps -eo pid,comm,%cpu --sort=-%cpu | head -n 11
}

function linux_gnome_extensions_memory() {
  ps -eo size,pid,user,command --sort -size | grep gnome-shell | awk '{hr=$1/1024; printf("%.2f MB ",hr)}{for (x=4;x<=NF;x++){printf("%s ",$x)}print ""}' | head -n 10
}

function gnome_update_extensions() {
  function update_dash_to_dock() {
    local current_dir=$(pwd)
    cd $HOME/Projects/src/github.com/micheleg/dash-to-dock
    git reset --hard
    git pull && git prune && git gc --aggressive

    export SASS=dart
    make install

    cd $current_dir
  }

  function update_net_speed() {
    local current_dir=$(pwd)
    cd $HOME/Projects/src/github.com/hedayaty/NetSpeed
    git reset --hard
    git pull && git prune && git gc --aggressive

    make install
    make enable
    make refresh

    cd $current_dir
  }

  update_dash_to_dock
  update_net_speed
}
