# kubectl path
install_kubectl(){
	local CURRENTDIR=$(pwd)
  cd ~/Downloads
	sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	# sudo chmod +x ./kubectl
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
}


if test -f "/usr/local/bin/kubectl"; then
else
    install_kubectl
	# local CURRENTDIR=$(pwd)
    # cd ~/Downloads
	# sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	# # sudo chmod +x ./kubectl
    # sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
fi



docker_start_all(){
	docker restart $(docker ps -a -q)
}

docker_stop_all(){
	docker stop $(docker ps -a -q)
}

docker_cleanup(){
	docker rmi $(docker images -f dangling=true -q)
}

docker_cleanup_volumes(){
  	docker volume rm $(docker volume ls -f dangling=true -q) 
}

# docker images to pull and start

docker_fetch_elasticsearch(){
	#docker run -d -p 9200:9200 -p 9300:9300 elasticsearch:latest
	docker run -d -p 9200:9200 -p 9300:9300 elasticsearch:2.3.5
}

docker_fetch_nats(){
	docker run -d -p 4222:4222 -p 6222:6222 -p 8222:8222 nats
}