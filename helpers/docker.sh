#!/bin/zsh

# docker.sh : Helpers for docker

function docker_start_all(){
	docker restart $(docker ps -a -q)
}

function docker_stop_all(){
	docker stop $(docker ps -a -q)
}

function docker_cleanup(){
	docker_cleanup_images
	docker_cleanup_volumes
}

function docker_cleanup_images(){
	docker rmi $(docker images -f dangling=true -q) || true
}

function docker_cleanup_volumes(){
  docker volume rm $(docker volume ls -f dangling=true -q) || true
}

# docker images to pull and start

function docker_fetch_elasticsearch(){
	#docker run -d -p 9200:9200 -p 9300:9300 elasticsearch:latest
	docker run -d -p 9200:9200 -p 9300:9300 elasticsearch:2.3.5
}

function docker_fetch_nats(){
	docker run -d -p 4222:4222 -p 6222:6222 -p 8222:8222 nats
}