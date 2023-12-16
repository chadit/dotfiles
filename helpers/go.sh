# go.sh : commands to help with go operations.

# Function to parse Go version number
local function parse_version() {
    echo "$1" | awk -F. '{ print $1 * 10000 + $2 * 100 + $3; }'
}

function go_update_linux(){
    # Get the current Go version, if Go is installed
    if command -v go >/dev/null 2>&1; then
        local current_go_version=$(go version | awk '{print $3}' | cut -d "o" -f2)
        local current_version=$(parse_version "$current_go_version")
    else
        local current_version=0
        echo "Go is not currently installed."
    fi

    # Fetch the latest Go version from the URL
    local latest_go_version=$(curl -s https://go.dev/VERSION\?m\=text | head -n 1 | cut -d " " -f1 | cut -d "o" -f2)
    local latest_version=$(parse_version "$latest_go_version")
    
    echo "Current Go version: $current_go_version"
    echo "Latest Go version: $latest_go_version"

    # Compare versions and install if the latest is newer
    if [ "$latest_version" -gt "$current_version" ]; then
        local CURRENTDIR=$(pwd)

        echo "Newer version of Go detected. Downloading and installing $latest_go_version..."

        local FILETAR="go${latest_go_version}.linux-amd64.tar.gz"
        local INSTALLPATH="/usr/local/go"
        
        # Remove the old version and install the new one
        if [ -d ${INSTALLPATH} ]; then
            sudo rm -rf ${INSTALLPATH}
        fi

        # change directory to tmp
        cd /tmp/

        # Download the latest version
        wget https://go.dev/dl/${FILETAR}

        sudo tar -C /usr/local -xzf ${FILETAR}
    
        echo "Installation of Go $latest_go_version complete."
        rm ${FILETAR}

        cd $CURRENTDIR

        # setup folders
        if [ ! -f ${INSTALLPATH} ]; then
            local logged_in_user=$(who | awk '{print $1}' | sort | uniq | grep -v root | head -n 1)

            sudo mkdir -p ${INSTALLPATH}
            # make folders to build windows exe's on linux
            sudo mkdir -p ${INSTALLPATH}/pkg/windows_amd64
            sudo mkdir -p ${INSTALLPATH}/pkg/windows_amd64/runtime
            sudo mkdir -p ${INSTALLPATH}/pkg/windows_amd64/runtime/internal/
            sudo chown -R ${logged_in_user} ${INSTALLPATH}/pkg/windows_amd64
        fi

        
    else
        echo "Go is up to date."
    fi
}

function go_setup() {
    export GOPATH=$HOME/Projects
    if [ -d /usr/lib64/golang/ ]; then
        export GOROOT="/usr/lib64/golang"
    fi

    if [ -d /usr/local/go ]; then
        export GOROOT="/usr/local/go"
    fi

    # if https://github.com/go-nv/goenv is installed, init it.
    # in go programming this is not really needed unless there is a really good reason to use a different version of go.
    # example: cloud go runner that is not the latest version of go.
    if [ -d "$HOME/.goenv/bin" ]; then
        pathmunge $HOME/.goenv/bin
        export GOENV_ROOT="$HOME/.goenv"
        export PATH="$GOENV_ROOT/bin:$PATH"
        eval "$(goenv init -)"
    fi

    if [ -z "$GOROOT" ]; then
        echo "GOROOT is not set."
    else
        #export GOCACHE=off <-- required on by default as of 1.12
        GOFLAGS="-count=1" # <-- suppose to prevent test from being cached
        export GO111MODULE=on
        export GOBIN=$GOPATH/bin
        pathmunge $GOROOT
        pathmunge $GOPATH
        pathmunge $GOROOT/bin
        pathmunge $GOPATH/bin

        echo $(go version)
    fi
}

go_tools_install() {
    local tools=(
        "github.com/golangci/golangci-lint/cmd/golangci-lint"
        "github.com/go-delve/delve/cmd/dlv"
        "github.com/fullstorydev/grpcurl/cmd/grpcurl"
        "google.golang.org/grpc/cmd/protoc-gen-go-grpc"
        "google.golang.org/protobuf/cmd/protoc-gen-go"
        "github.com/mattn/efm-langserver"
        "golang.org/x/tools/gopls"
        "mvdan.cc/gofumpt"
        "github.com/vadimi/grpc-client-cli/cmd/grpc-client-cli"
        "github.com/UltiRequiem/yamlfmt"
        "github.com/cweill/gotests/gotests"
        "github.com/fatih/gomodifytags"
        "github.com/josharian/impl"
        "github.com/haya14busa/goplay/cmd/goplay"
        "golang.org/x/vuln/cmd/govulncheck"
        "github.com/bufbuild/buf/cmd/buf"
        "github.com/mrtazz/checkmake/cmd/checkmake"
    )

    for tool in "${tools[@]}"; do
        go install "${tool}@latest"
    done
}

go_clean_mod() {
    go clean -modcache
}