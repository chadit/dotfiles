#!/bin/bash

# Setup Kubernetes and minicube
func ()
{
	# change directory to tmp
    cd /tmp/
	curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
	sudo chmod +x ./kubectl
	sudo mv ./kubectl /usr/local/bin/kubectl

	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 
	sudo chmod +x minikube 
	sudo mv minikube /usr/local/bin/

}
func