function git_cleanup() {
	go clean -x
	git prune && git gc --aggressive
}

function git_prune() {
	local CURRENTDIR=$(pwd)
	local BASEDIR="$HOME/Projects/src"
	
	cd $BASEDIR
	for i in $(find . -name ".git" | cut -c 3-); do
		cd "$i"
		cd ..
		echo $(pwd)
		git prune && git gc --aggressive
		cd $BASEDIR
	done

	cd $CURRENTDIR
}

function git_rebase() {
	branch=$1
	echo "rebase branch ($branch) for git"
	git fetch origin
	git rebase origin/$branch
	echo "completed the rebase of the branch"
	#git push -f
}

function git_pull() {
	git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
	git fetch --all && git pull --all && git prune && git gc --aggressive

	#git fetch --all && git pull --all && git prune && git gc --aggressive
}

function git_branch_cleanup() {
	git fetch -p && LANG=c git branch -vv | awk '/: gone]/&&!/^*/{print $1}' | xargs git branch -d
}

#Create a new branch git and github
function git_branch_create() {
	name=$1
	echo "creating a new branch ($name) for git"
	git pull
	git checkout -b $name
	git push origin $name
	git push --set-upstream origin $name
	echo "completed the creation of the branch"
}

# Reset a branch with Origin
function git_branch_reset() {
	git fetch --prune
	git reset --hard @{upstream}
	git clean -x -d -f
	#git prune && git gc --aggressive
}

function git_branch_prune() {
	git prune && git gc --aggressive
}

function git_branch_delete() {
	name=$1
	echo "remove branch $name"
	if [ "$(git branch --list develop)" ]; then
		git checkout develop
	else
		if [ "$(git branch --list)" ]; then
			git checkout main
		else
			git checkout master
		fi
	fi

	git push origin --delete $name
	git branch -D $name
}

function git_merge_no_commit() {
	git add -A
	git commit --amend

	#`git commit --amend`
	#vim comes up, you `:q` out of it
	#`git push -f`
	#that will update the last commit
}

function git_update_folder() {
	local CURRENTDIR=$(pwd)
	local FOLDER=$1
	echo $FOLDER
	if [ -z "$FOLDER" ]; then
		echo "no value"
		return
	fi
	cd $FOLDER
	for d in */; do
		if [ -d "$d" ]; then
			#git config core.filemode false
			echo " --- start --- "
			cd $d && echo $(pwd) && branch_reset && git pull && go clean -cache && git prune && git gc --aggressive
			echo " --- end --- "
		fi
		cd $FOLDER
	done
	cd $CURRENTDIR
}

function git_update_dependancy_repos() {
  # List of Git repositories to update

  # tries to get the logged in user, if multiple users are logged in, it will get the first one.
  local logged_in_user=$(who | awk '{print $1}' | sort | uniq | grep -v root | head -n 1)

  REPOS=(
    "/home/${logged_in_user}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    "/home/${logged_in_user}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  )
  
  # Loop through all repositories and update them
  for repo in "${REPOS[@]}"; do
    if [ -d "$repo" ]; then
      echo "Updating repository: $repo"
      git -C "$repo" pull
		fi
  done

}