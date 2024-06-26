
function java_setup() {
  java_sdkman_init
  # after sdkman just in case it's not installed
  java_set_home

  if command -v java >/dev/null 2>&1; then
    java -version 2>&1 | head -n 1
  fi
}

function java_sdkman_upgrade_latest() {
  sdk selfupdate
  sdk update
  sdk upgrade
}

# TODO; still not loading correctly on new systems.
function java_sdkman_init() {
  if test -f "$HOME/.sdkman/bin/sdkman-init.sh"; then
    # echo "sdkman found"
    # curl -s "https://get.sdkman.io" | bash
    # shellcheck source=/dev/null # to ignore the error BASH Language Server
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    if ! command -v java &> /dev/null; then
      echo "sdkman found, but not installed, installing, restart shell when done"
      java_sdkman_upgrade_latest
      # install and init java
      sdk install java
      sdk current java
    fi
  else
    echo "sdkman not found, installing, restart shell when done"
    curl -s "https://get.sdkman.io" | bash
    # install and init java
    sdk install java
    sdk current java
    
    source "$HOME/.sdkman/bin/sdkman-init.sh"
  fi
}

function java_set_home() {
  # Check if JAVA_HOME is not already set
if [ -z "$JAVA_HOME" ]; then
  if test -f "/usr/libexec/java_home"; then
    # echo "test"
    export JAVA_HOME=$(/usr/libexec/java_home)
    pathmunge $JAVA_HOME/bin
  else
    # if jvm is not installed, then ensure it is setup
    if [ ! -d /usr/lib/jvm ]; then
echo "No Java installation found."

    fi
    # Find available Java versions and sort them
    available_javas=$(find /usr/lib/jvm -maxdepth 1 -type d -name "java-*-openjdk" | sort -V)

    if [ -n "$available_javas" ]; then
        # Get the highest version
        highest_java=$(echo "$available_javas" | tail -n1)
        
        # Set JAVA_HOME to the highest version found
        export JAVA_HOME=$highest_java
        pathmunge $JAVA_HOME/bin
    else
        echo "No suitable Java installation found."
    fi
  fi
fi
}