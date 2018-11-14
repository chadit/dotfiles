#!/bin/bash

# Setup Kubernetes and minicube
func ()
{

	# install/update pip
	python -mplatform | grep -qi Manjaro && sudo pacman -S python2-pip #python v2
	python -mplatform | grep -qi Manjaro && sudo pacman -S python-pip #python v3

	#Ansible python libraries 
	#used for connecting to AWS ELS
	pip install boto boto3 --user
	#AWS cli
	pip install awscli --upgrade --user

	# change directory to tmp
    cd /tmp/
	curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
	sudo chmod +x /tmp/kubectl
	sudo mv /tmp/kubectl /usr/local/bin/kubectl

	curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 
	sudo chmod +x /tmp/minikube 
	sudo mv /tmp/minikube /usr/local/bin/

#	sudo rm kubectl
#	sudo rm minikube

}
func


# Examples
# kubectl run elasticsearch235 --image=elasticsearch:2.3.5 --port=9200 --port=9300