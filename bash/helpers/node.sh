node_install_locations(){
	npm install -g nodist
}

node_update_npm_latest(){
	npm install -g npm@latest
}

PATH="$HOME/.local/bin:$PATH"
export npm_config_prefix="$HOME/.local"