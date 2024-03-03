# kubectl path
function kube_setup() {
 if ! command -v kubectl &> /dev/null; then
    echo "setup kubectl"
    # Install kubectl
    kube_install_kubectl
  else
    #echo "kubectl is already installed"
    current_version=v$(kubectl version --client | head -n 1 | sed 's/Client Version: v//')
    echo "kubectl: $current_version"
    source <(kubectl completion zsh)
  fi
}

function kube_install_kubectl(){
#  if command -v kubectl >/dev/null 2>&1; then
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
 # fi
}

function kube_cleanup_all(){
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
