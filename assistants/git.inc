
[ -z "$(which git)" ] && return 1

# If git repo return 0 else 1
is_git_repo() {
	[ -e .git ] && return 0
	echo "No git repository here"
	return 1
}

git_log() {
	#is_git_repo;  (( $? )) && return 1
	git log --graph --decorate --all --pretty="format:%C(3)%h %C(2)%an %Creset%s %C(auto)%d"
}

git_log_extended() {
	git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all
}

git_log_alt() {
	git log --branches --not --remotes --simplify-by-decoration --decorate --oneline
}

git_branch() {
	#is_git_repo;  (( $? )) && return 1
	git branch -a -vv
}

git_status() {
	#is_git_repo;  (( $? )) && return 1
	git status -s
}

git_current_branch() {
	git rev-parse --abbrev-ref HEAD
}

git_branch_name() {
	git_current_branch
}

git_unpushed_commits_number() {
	NUMBER=$(git rev-list @{upstream}..HEAD --count 2>/dev/null)
	[ "$NUMBER" != "0" ] && echo $NUMBER
}

git_is_uncommited_changes() {
	[ ! -z "$(git status -s)" ] && echo M
}

#git_repo_name() {
#	git name-rev --name-only HEAD
#}

git_repo_name() {
	local REMOTES=$(git remote -v)
	#readarray -t REMOTES <<< "$REMOTES"
	for REMOTE in "$REMOTES"; do
		[[ "$REMOTE" =~ "(fetch)" ]] && local REMOTE_URL=${REMOTE%% (fetch)*}
	done

	# Cleaning
	local REMOTE_REPO_NAME=${REMOTE_URL##*/}
	REMOTE_REPO_NAME=${REMOTE_REPO_NAME%.git}

	echo $REMOTE_REPO_NAME
}

git_recursive_status() {
	find ./ -name .git -printf "%h\n" -execdir git status --short \;
}

alias gil='git_log'
alias gill='git_log_extended'
alias gib='git_branch'
alias gis='git_status'
alias girs='git_recursive_status'
alias gia='git add'
alias gic='git commit'

