#!/bin/bash

# VSCODE

# Installing github.com/uudashr/gopkgs/cmd/gopkgs SUCCEEDED
# Installing github.com/ramya-rao-a/go-outline SUCCEEDED
# Installing github.com/acroca/go-symbols SUCCEEDED
# Installing golang.org/x/tools/cmd/guru SUCCEEDED
# Installing golang.org/x/tools/cmd/gorename SUCCEEDED
# Installing github.com/go-delve/delve/cmd/dlv SUCCEEDED
# Installing github.com/stamblerre/gocode SUCCEEDED
# Installing github.com/rogpeppe/godef SUCCEEDED
# Installing golang.org/x/lint/golint SUCCEEDED
# Installing github.com/cweill/gotests/... SUCCEEDED
# Installing github.com/fatih/gomodifytags SUCCEEDED
# Installing github.com/josharian/impl SUCCEEDED
# Installing github.com/davidrjenni/reftools/cmd/fillstruct SUCCEEDED
# Installing github.com/haya14busa/goplay/cmd/goplay SUCCEEDED
# Installing github.com/godoctor/godoctor SUCCEEDED

# ###############################3


func ()
{
	local GO=go
	local GIT=git
	
	echo "Install/Upgrading go tools ..."

	echo "vim packages" 

	# https://github.com/fatih/vim-go/blob/c2fa1a1762db5d542bbbb1e5bc752684692bf570/plugin/go.vim

	if [ -d "$HOME/Projects/src/github.com/klauspost/asmfmt" ]; then
   		cd $HOME/Projects/src/github.com/klauspost/asmfmt && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go clean -cache && go install
   		cd $HOME/Projects/src/github.com/klauspost/asmfmt/cmd/asmfmt && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/go-delve/delve" ]; then
   		cd $HOME/Projects/src/github.com/go-delve/delve && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go clean -cache
   		cd $HOME/Projects/src/github.com/go-delve/delve/cmd/dlv && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/kisielk/errcheck" ]; then
		if [ -d "$HOME/Projects/src/github.com/kisielk/gotool" ]; then
			cd $HOME/Projects/src/github.com/kisielk/gotool && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
		fi
   		cd $HOME/Projects/src/github.com/kisielk/errcheck && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/davidrjenni/reftools" ]; then
		cd $HOME/Projects/src/github.com/davidrjenni/reftools && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
   		cd $HOME/Projects/src/github.com/davidrjenni/reftools/cmd/fillstruct && echo `pwd` && go install
   		cd $HOME/Projects/src/github.com/davidrjenni/reftools/cmd/fillstruct && echo `pwd` && go install
   		cd $HOME/Projects/src/github.com/davidrjenni/reftools/cmd/fillswitch && echo `pwd` && go install
	fi

	 if [ -d "$HOME/Projects/src/github.com/stamblerre/gocode" ]; then
	 		gocode close
    		cd $HOME/Projects/src/github.com/stamblerre/gocode && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	 fi

	if [ -d "$HOME/Projects/src/github.com/zmb3/gogetdoc" ]; then
   		cd $HOME/Projects/src/github.com/zmb3/gogetdoc && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/golang.org/x/tools" ]; then
		cd $HOME/Projects/src/golang.org/x/tools && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive 
   		cd $HOME/Projects/src/golang.org/x/tools/cmd/goimports && echo `pwd` && go install
   		cd $HOME/Projects/src/golang.org/x/tools/cmd/gorename && echo `pwd` && go install
   		cd $HOME/Projects/src/golang.org/x/tools/cmd/guru && echo `pwd` && go install
   		cd $HOME/Projects/src/golang.org/x/tools/cmd/gotype && echo `pwd` && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/golang/lint" ]; then
		cd $HOME/Projects/src/github.com/golang/lint && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
   		cd $HOME/Projects/src/github.com/golang/lint/golint && echo `pwd` && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/alecthomas/gometalinter" ]; then
   		cd $HOME/Projects/src/github.com/alecthomas/gometalinter && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/fatih/gomodifytags" ]; then
   		cd $HOME/Projects/src/github.com/fatih/gomodifytags && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/jstemmer/gotags" ]; then
  		cd $HOME/Projects/src/github.com/jstemmer/gotags && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/koron/iferr" ]; then
   		cd $HOME/Projects/src/github.com/koron/iferr && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/josharian/impl" ]; then
  		cd $HOME/Projects/src/github.com/josharian/impl && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/dominikh/go-tools" ]; then
		if [ -d "$HOME/Projects/src/honnef.co/go/tools" ]; then
			cd $HOME/Projects/src/honnef.co/go/tools && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
		fi

		cd $HOME/Projects/src/github.com/dominikh/go-tools && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
   		cd $HOME/Projects/src/github.com/dominikh/go-tools/cmd/keyify && echo `pwd` && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/fatih/motion" ]; then
   		cd $HOME/Projects/src/github.com/fatih/motion && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	# for a vim plugin
	if [ -d "$HOME/Projects/src/github.com/universal-ctags/ctags" ]; then
   		cd $HOME/Projects/src/github.com/universal-ctags/ctags && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
   		echo "starting installation"
   		sudo ./autogen.sh
		sudo ./configure --prefix=/usr/local
		sudo make
		sudo make install
		sudo chown -R $(whoami) ~/Projects/src/github.com/universal-ctags
	fi

	echo "vscode"
	if [ -d "$HOME/Projects/src/github.com/ramya-rao-a/go-outline" ]; then
 		cd $HOME/Projects/src/github.com/ramya-rao-a/go-outline && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/newhook/go-symbols" ]; then
   		cd $HOME/Projects/src/github.com/newhook/go-symbols && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/sourcegraph/go-langserver" ]; then
   		cd $HOME/Projects/src/github.com/sourcegraph/go-langserver && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/sqs/goreturns" ]; then
   		cd $HOME/Projects/src/github.com/sqs/goreturns && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/ianthehat/godef" ]; then
   		cd $HOME/Projects/src/github.com/ianthehat/godef && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/uudashr/gopkgs" ]; then
		if [ -d "$HOME/Projects/src/github.com/karrick/godirwalk" ]; then
   			cd $HOME/Projects/src/github.com/karrick/godirwalk && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
		fi
		if [ -d "$HOME/Projects/src/github.com/pkg/errors" ]; then
   			cd $HOME/Projects/src/github.com/pkg/errors && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
		fi
   		cd $HOME/Projects/src/github.com/uudashr/gopkgs && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
   		cd $HOME/Projects/src/github.com/uudashr/gopkgs/cmd/gopkgs && echo `pwd` && go install
	fi

	echo "gometalinter"
	if [ -d "$HOME/Projects/src/github.com/alecthomas/gocyclo" ]; then
   		cd $HOME/Projects/src/github.com/alecthomas/gocyclo && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/securego/gosec" ]; then
		if [ -d "$HOME/Projects/src/github.com/nbutton23/zxcvbn-go" ]; then
   			cd $HOME/Projects/src/github.com/nbutton23/zxcvbn-go && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
		fi
		if [ -d "$HOME/Projects/src/github.com/ryanuber/go-glob" ]; then
   			cd $HOME/Projects/src/github.com/ryanuber/go-glob && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
		fi

   		cd $HOME/Projects/src/github.com/securego/gosec && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
   		cd $HOME/Projects/src/github.com/securego/gosec/cmd/gosec && echo `pwd` && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/mdempsky/unconvert" ]; then
   		cd $HOME/Projects/src/github.com/mdempsky/unconvert && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	if [ -d "$HOME/Projects/src/github.com/tsenart/deadcode" ]; then
   		cd $HOME/Projects/src/github.com/tsenart/deadcode && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	echo "everything else"
	if [ -d "$HOME/Projects/src/github.com/lyze/posh-git-sh/git-prompt.sh" ]; then
   		cd $HOME/Projects/src/github.com/lyze/posh-git-sh/git-prompt.sh && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	# make done in go
	if [ -d "$HOME/Projects/src/github.com/magefile/mage" ]; then
   		cd $HOME/Projects/src/github.com/magefile/mage && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	# go vendor tool
	if [ -d "$HOME/Projects/src/github.com/golang/dep" ]; then
   		cd $HOME/Projects/src/github.com/golang/dep && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	# go tool to merge coverage
	if [ -d "$HOME/Projects/src/github.com/wadey/gocovmerge" ]; then
   		cd $HOME/Projects/src/github.com/wadey/gocovmerge && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi

	# go tool for swagger
	if [ -d "$HOME/Projects/src/github.com/go-swagger/go-swagger" ]; then
   		cd $HOME/Projects/src/github.com/go-swagger/go-swagger && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
		cd $HOME/Projects/src/github.com/go-swagger/go-swagger/cmd/swagger && go install
	fi

	# go markdown blogger
	if [ -d "$HOME/Projects/src/github.com/gohugoio/hugo" ]; then
   		cd $HOME/Projects/src/github.com/gohugoio/hugo && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	# go crypto
	if [ -d "$HOME/Projects/src/golang.org/x/crypto/" ]; then
   		cd $HOME/Projects/src/golang.org/x/crypto/ && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	# The terminal that I use
	if [ -d "$HOME/Projects/src/github.com/jwilm/alacritty" ]; then
   		cd $HOME/Projects/src/github.com/jwilm/alacritty && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	# ---------------------------------------------------------------------- #
	# Add ons that should really be vendored
	if [ -d "$HOME/Projects/src/github.com/julienschmidt/httprouter" ]; then
   		cd $HOME/Projects/src/github.com/julienschmidt/httprouter && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/nats-io/gnatsd" ]; then
   		cd $HOME/Projects/src/github.com/nats-io/gnatsd && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/nats-io/go-nats" ]; then
   		cd $HOME/Projects/src/github.com/nats-io/go-nats && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/nats-io/go-nats-streaming" ]; then
   		cd $HOME/Projects/src/github.com/nats-io/go-nats-streaming && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/nats-io/nats" ]; then
   		cd $HOME/Projects/src/github.com/nats-io/nats && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/nats-io/nats.go" ]; then
   		cd $HOME/Projects/src/github.com/nats-io/nats.go && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/nats-io/nuid" ]; then
   		cd $HOME/Projects/src/github.com/nats-io/nuid && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/nats-io/nkeys" ]; then
   		cd $HOME/Projects/src/github.com/nats-io/nkeys && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/paulmach/go.geojson" ]; then
   		cd $HOME/Projects/src/github.com/paulmach/go.geojson && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/paulmach/go.geo" ]; then
   		cd $HOME/Projects/src/github.com/paulmach/go.geo && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/satori/go.uuid" ]; then
   		cd $HOME/Projects/src/github.com/satori/go.uuid && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/kr/pretty" ]; then
   		cd $HOME/Projects/src/github.com/kr/pretty && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/kr/text" ]; then
   		cd $HOME/Projects/src/github.com/kr/text && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/dgrijalva/jwt-go" ]; then
   		cd $HOME/Projects/src/github.com/dgrijalva/jwt-go && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/github.com/google/uuid" ]; then
   		cd $HOME/Projects/src/github.com/github.com/google/uuid && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/github.com/lib/pq" ]; then
   		cd $HOME/Projects/src/github.com/github.com/lib/pq && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/github.com/xeipuuv/gojsonschema" ]; then
   		cd $HOME/Projects/src/github.com/github.com/xeipuuv/gojsonschema && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/github.com/xeipuuv/gojsonreference" ]; then
   		cd $HOME/Projects/src/github.com/github.com/xeipuuv/gojsonreference && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/github.com/xeipuuv/gojsonpointer" ]; then
   		cd $HOME/Projects/src/github.com/github.com/xeipuuv/gojsonpointer && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/github.com/rlmcpherson/s3gof3r" ]; then
   		cd $HOME/Projects/src/github.com/github.com/rlmcpherson/s3gof3r && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/github.com/aws/aws-lambda-go" ]; then
   		cd $HOME/Projects/src/github.com/github.com/aws/aws-lambda-go && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/github.com/aws/aws-sdk-go" ]; then
   		cd $HOME/Projects/src/github.com/github.com/aws/aws-sdk-go && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/iancoleman/orderedmap" ]; then
   		cd $HOME/Projects/src/github.com/iancoleman/orderedmap && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/tealeg/xlsx" ]; then
   		cd $HOME/Projects/src/github.com/tealeg/xlsx && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/tealeg/xlsx" ]; then
   		cd $HOME/Projects/src/github.com/tealeg/xlsx && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/DataDog/zstd" ]; then
   		cd $HOME/Projects/src/github.com/DataDog/zstd && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/src/github.com/pierrec/lz4" ]; then
   		cd $HOME/Projects/src/github.com/pierrec/lz4 && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	# ---------------------------------------------------------------------- #

	# ******************************************* ZSH Plugins ************************************
	if [ -d "$HOME/Projects/helpers/Scripts/Home/.zsh/plugins/zsh-autosuggestions" ]; then
   		cd $HOME/Projects/helpers/Scripts/Home/.zsh/plugins/zsh-autosuggestions && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi

	if [ -d "$HOME/Projects/helpers/Scripts/Home/.zsh/plugins/zsh-git-prompt" ]; then
   		cd $HOME/Projects/helpers/Scripts/Home/.zsh/plugins/zsh-git-prompt && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive
	fi
	# *********************************************************************************************

	# ********************************* Benchmarking Tool *****************************************
	if [ -d "$HOME/Projects/src/github.com/rakyll/hey" ]; then
   		cd $HOME/Projects/src/github.com/rakyll/hey && echo `pwd` && branch_reset && git pull && git prune && git gc --aggressive && go install
	fi




	

	# Get/Update/Install
	# echo "starting gometalinter"
	# go get -u github.com/alecthomas/gometalinter
	# gometalinter --install

	# use https://github.com/docker/docker-credential-helpers/releases to install cred
}

# Reset a branch with Origin
branch_reset(){
 git fetch --prune
 git reset --hard @{upstream}
 git clean -x -d -f
}

func
