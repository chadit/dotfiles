node_install_locations(){
	npm install -g nodist
}

node_update_npm_latest(){
	npm install -g npm@latest
}

node_dependencies(){
	npm install -g vscode-css-languageserver-bin
	npm install -g dockerfile-language-server-nodejs
	npm install -g graphql-language-service-cli
	npm install -g vscode-html-languageserver-bin
  npm install -g typescript typescript-language-server
  npm install -g vscode-json-languageserver
  npm install -g yaml-language-server
	# npm install -g aws-cdk
	
  npm init @eslint/config
}

PATH="$HOME/.local/bin:$PATH"
export npm_config_prefix="$HOME/.local"