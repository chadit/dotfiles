syncthing_pause(){
	curl -X POST -H "X-API-Key: $SYNCTHINGKEY" http://localhost:8384/rest/system/pause
}

syncthing_start(){
	curl -X POST -H "X-API-Key: $SYNCTHINGKEY" http://localhost:8384/rest/system/resume
}