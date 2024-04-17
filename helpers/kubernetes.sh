# kubectl path
function kube_setup() {
  if ! command -v kubectl &>/dev/null; then
    echo "setup kubectl"
    # Install kubectl

    # Determine OS
    OS="linux"
    if [[ "$OSTYPE" == "darwin"* ]]; then
      OS="darwin"
    fi

    if [[ "$OS" == "linux" ]]; then
      kube_install_kubectl_linux
    else
      kube_install_kubectl_mac
    fi
  else
    #echo "kubectl is already installed"
    current_version=v$(kubectl version --client | head -n 1 | sed 's/Client Version: v//')
    echo "kubectl: $current_version"
    source <(kubectl completion zsh)
  fi
}

function kube_install_kubectl_linux() {
  local CURRENTDIR=$(pwd)

  current_version=v$(kubectl version --client | head -n 1 | sed 's/Client Version: v//')
  echo "Current version of kubectl: $current_version"

  latest_version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
  echo "Latest version of kubectl: $latest_version"

  if [ "$(printf '%s\n' "$latest_version" "$current_version" | sort -V | head -n1)" != "$latest_version" ]; then
    echo "Updating kubectl to the latest version: $latest_version"
    # change directory to tmp
    cd /tmp/
    sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    # sudo chmod +x ./kubectl
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # Update kubectl command here (depends on your installation method)

    cd $CURRENTDIR
  else
    echo "kubectl is already at the latest version."
  fi
}

function kube_install_kubectl_mac() {
  local CURRENTDIR=$(pwd)

  current_version=v$(kubectl version --client | head -n 1 | sed 's/Client Version: v//')
  echo "Current version of kubectl: $current_version"

  latest_version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
  echo "Latest version of kubectl: $latest_version"

  if [ "$(printf '%s\n' "$latest_version" "$current_version" | sort -V | head -n1)" != "$latest_version" ]; then
    echo "Updating kubectl to the latest version: $latest_version"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"
    cd $CURRENTDIR
  else
    echo "kubectl is already at the latest version."
  fi
}

function kube_install_minikube() {
  # Function to compare semantic versions
  version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

  # Determine OS
  OS="linux"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="darwin"
  fi

  # Determine Architecture
  ARCH="amd64"
  if [[ "$(uname -m)" == "arm64" ]]; then
    ARCH="arm64"
  elif [[ "$(uname -m)" == "aarch64" ]]; then
    ARCH="arm64"
  elif [[ "$(uname -m)" == "x86_64" ]]; then
    ARCH="amd64"
  fi

  # Check current installed version of Minikube
  INSTALLED_VERSION=""
  if command -v minikube &>/dev/null; then
    INSTALLED_VERSION=$(minikube version --short | sed 's/v//')
    echo "Current installed Minikube version: $INSTALLED_VERSION"
  else
    echo "Minikube not installed."
  fi

  # Fetch the latest Minikube version from GitHub
  LATEST_VERSION=$(curl -s https://api.github.com/repos/kubernetes/minikube/releases/latest | grep 'tag_name' | cut -d '"' -f 4 | sed 's/v//')

  echo "Latest Minikube version: $LATEST_VERSION"

  # Compare versions and install/update if necessary
  if [[ -z "$INSTALLED_VERSION" ]] || version_gt $LATEST_VERSION $INSTALLED_VERSION; then
    echo "Installing/Updating Minikube..."
    # Form the download URL
    DOWNLOAD_URL="https://storage.googleapis.com/minikube/releases/latest/minikube-${OS}-${ARCH}"

    # Download and install Minikube
    curl -Lo minikube $DOWNLOAD_URL
    chmod +x minikube

    # Move to executable path
    sudo mv minikube /usr/local/bin/minikube

    # Verify installation
    minikube version
    echo "Minikube has been successfully installed/updated."
  else
    echo "You are already using the latest version of Minikube."
  fi
}

function kube_cleanup_all() {
  echo "kubectl delete crds"
  kubectl delete crds --all
  echo "kubectl delete deployments"
  kubectl delete deployments --all
  echo "kubectl delete pods"
  kubectl delete pods --all
  echo "kubectl delete services"
  kubectl delete services --all
  #kubectl delete all --all
}
