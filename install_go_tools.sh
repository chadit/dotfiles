#!/bin/bash

func ()
{
	echo "Install/Upgrading go tools ..."
	# check if folder exist, and reset them (sometimes syncing can cause issues)
	if [ -d "/home/chadit/Projects/src/cloud.google.com/go" ]; then
  		cd /home/chadit/Projects/src/cloud.google.com/go && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/golang.org/x/tools/cmd" ]; then
  		cd /home/chadit/Projects/src/golang.org/x/tools/cmd && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/golang.org/x/tools/cmd/gorename" ]; then
  		cd /home/chadit/Projects/src/golang.org/x/tools/cmd/gorename && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/golang.org/x/tools/cmd/guru" ]; then
  		cd /home/chadit/Projects/src/golang.org/x/tools/cmd/guru && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/golang.org/x/tools/cmd/cover" ]; then
  		cd /home/chadit/Projects/src/golang.org/x/tools/cmd/cover && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/github.com/derekparker/delve/cmd/dlv" ]; then
  		cd /home/chadit/Projects/src/github.com/derekparker/delve/cmd/dlv && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/github.com/nsf/gocode" ]; then
  		cd /home/chadit/Projects/src/github.com/nsf/gocode && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/github.com/rogpeppe/godef" ]; then
  		cd /home/chadit/Projects/src/github.com/rogpeppe/godef && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/github.com/golang/lint" ]; then
  		cd /home/chadit/Projects/src/github.com/golang/lint && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/github.com/golang/lint/golint" ]; then
  		cd /home/chadit/Projects/src/github.com/golang/lint/golint && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/github.com/lukehoban/go-outline" ]; then
  		cd /home/chadit/Projects/src/github.com/lukehoban/go-outline && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/github.com/cweill/gotests" ]; then
  		cd /home/chadit/Projects/src/github.com/cweill/gotests && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/github.com/sourcegraph/go-langserver" ]; then
  		cd /home/chadit/Projects/src/github.com/sourcegraph/go-langserver && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi
	if [ -d "/home/chadit/Projects/src/github.com/alecthomas/gometalinter" ]; then
  		cd /home/chadit/Projects/src/github.com/alecthomas/gometalinter && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi

	if [ -d "/home/chadit/Projects/src/github.com/ramya-rao-a/go-outline" ]; then
  		cd /home/chadit/Projects/src/github.com/ramya-rao-a/go-outline && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi

	if [ -d "/home/chadit/Projects/src/sourcegraph.com/sqs/goreturns" ]; then
  		cd /home/chadit/Projects/src/sourcegraph.com/sqs/goreturns && echo `pwd` && reset_branch && git pull && git prune && git gc --aggressive
	fi

 	# not sure if used
   	# cd /home/chadit/Projects/src/github.com/josharian/impl && echo `pwd` && reset_branch && git pull && git prune    
    # cd /home/chadit/Projects/src/github.com/golang/glog && echo `pwd` && reset_branch && git pull && git prune
    # cd /home/chadit/Projects/src/github.com/golang/protobuf && echo `pwd` && reset_branch && git pull && git prune
    # cd /home/chadit/Projects/src/sourcegraph.com/sqs/goreturns && echo `pwd` && reset_branch && git pull && git prune
    # cd /home/chadit/Projects/src/github.com/tpng/gopkgs && echo `pwd` && reset_branch && git pull && git prune
    # cd /home/chadit/Projects/src/github.com/newhook/go-symbols && echo `pwd` && reset_branch && git pull && git prune
    # cd /home/chadit/Projects/src/github.com/cweill/gotests && echo `pwd` && reset_branch && git pull && git prune
    # cd /home/chadit/Projects/src/github.com/sourcegraph/go-langserver && echo `pwd` && reset_branch && git pull && git prune
    
    # gometalinter
    # cd /home/chadit/Projects/src/honnef.co/go/lint && echo `pwd` && reset_branch && git pull && git prune
    # cd /home/chadit/Projects/src/honnef.co/go/simple && echo `pwd` && reset_branch && git pull && git prune
    # cd /home/chadit/Projects/src/honnef.co/go/staticcheck && echo `pwd` && reset_branch && git pull && git prune
    # cd /home/chadit/Projects/src/honnef.co/go/tools && echo `pwd` && reset_branch && git pull && git prune
    # cd /home/chadit/Projects/src/github.com/alecthomas/gocyclo && echo `pwd` && reset_branch && git pull && git prune
    # cd /home/chadit/Projects/src/github.com/alecthomas/template && echo `pwd` && reset_branch && git pull && git prune
    # cd /home/chadit/Projects/src/github.com/alecthomas/units && echo `pwd` && reset_branch && git pull && git prune


	# Get/Update/Install
	go get -u github.com/derekparker/delve/cmd/dlv
	go get -u github.com/nsf/gocode && gocode close

	go get -u golang.org/x/tools/...
	go get -u golang.org/x/tools/cmd/gorename
	go get -u github.com/golang/lint/golint
	go get -u github.com/redefiance/go-find-references
	go get -u github.com/jstemmer/gotags
	go get -u github.com/client9/misspell/cmd/misspell
	go get -u github.com/redefiance/go-find-references
	go get -u github.com/adjust/go-wrk
	go get -u github.com/uber/go-torch
	go get -u github.com/rogpeppe/godef
	go get -u github.com/cweill/gotests/...
	go get -u github.com/lukehoban/go-outline
	go get -u github.com/ramya-rao-a/go-outline
	go get -u sourcegraph.com/sqs/goreturns

	go get -u honnef.co/go/tools/cmd/staticcheck
	go get -u honnef.co/go/tools/cmd/megacheck
	go get -u github.com/alecthomas/gometalinter
	gometalinter --install
}

# Reset a branch with Origin
reset_branch(){
 git fetch --prune
 git reset --hard @{upstream}
 git clean -x -d -f
}

func
