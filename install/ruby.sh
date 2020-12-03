#!/bin/bash

# Ruby setup utilizing rbenv so that the ruby versions can be swapped out
func ()
{
	if [ "$EUID" -eq 0 ]; then 
		echo "do not run as root"
  		exit
	fi

	#dependancies
	if [ -f "/usr/bin/apt" ]; then
  		platform="ubuntu"
	fi
	if [ -f "/usr/bin/dnf" ]; then
  		platform="fedora"
	fi

	if [ -f "/usr/bin/eopkg" ]; then
  		platform="solus"
	fi

	case "$platform" in
	"fedora")
		echo "fedora not setup" 
		;;
	"ubuntu")
		echo "run ubuntu stuff" 
		#sudo apt-get install -y libreadline-dev libssl-dev autoconf bison build-essential libssl-dev libyaml-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev

		# For Ruby < 2.4
		#sudo apt install -y libssl1.0-dev
		#sudo apt install -y rbenv ruby-sass

		sudo chown -R chadit /usr/share/rubygems-integration/all/
		gem pristine --all

		;;
	"solus")
		echo "solus not setup" 
		#sudo eopkg install -y curl containerd runc dnsmasq btrfs-progs
		;;
	esac

	if [ -d "$HOME/.rbenv" ]; then 
		echo "rbenv found"
		local CURRENTDIR=`pwd`
		cd ~/.rbenv &&  echo `pwd` && git pull
		cd ~/.rbenv/plugins/ruby-build &&  echo `pwd` && git pull
		cd $CURRENTDIR
	else
		echo "rbenv not found -- pulling "
		git clone git@github.com:rbenv/rbenv.git ~/.rbenv
		cd ~/.rbenv && src/configure && make -C src
		mkdir -p ~/.rbenv/shims
		mkdir -p ~/.rbenv/plugins
		~/.rbenv/bin/rbenv init
		curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
		rbenv init -
		git clone git@github.com:rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
	fi

	# this sets gems to user, this will cause rbenv to fail so we need to remove it
	sudo rm /etc/gemrc 

	# check rbenv setup
	curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash

	# install gems
	gem install seeing_is_believing solargraph rufo htmlbeautifier rbeautify rubocop bundler
}
func
