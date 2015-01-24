

BASE_ITEM=base


Red="\[\e[1;31m\]"
Yellow="\[\e[1;33m\]"
Blue="\[\e[1;34m\]"
Pink="\[\e[1;35m\]"
COff="\[\e[m\]"

add_paths() {
	for CUR_PATH in "${MODE_PATH[@]}"; do
		local ADD_PATH=$BASE_PATH/$CUR_PATH
		add_path "$ADD_PATH"
	done
}

add_path() {	
	local ADD_PATH=$1
	[[ ! $PATH =~ $ADD_PATH ]] && echo Adding $ADD_PATH to PATH && export PATH=$ADD_PATH:$PATH
}

mode_chk() {
	
	# Already in a mode
	[ ! -z "$CURRENT_SHELL_MODE" ] && is_exit_mode && return
	
	# No new mode is required
        [ ! -e "./$BASE_ITEM" ] && return
	
	# Load mode variables
	source $BASE_ITEM
	
	#if [ "$CURRENT_SHELL_MODE" != "$SHELL_MODE" ]; then
		
		export CURRENT_SHELL_MODE=$SHELL_MODE
		export OLD_PS1=$PS1
		export OLD_PATH=$PATH
		
		export BASE_PATH=$PWD
		export BACK_BASE=${PWD%/*}

		local GIT_REPO_NAME="$Blue$(git_repo_name)$COff"
		add_paths
		
		export PS1='\u@\h:'$Yellow'${PWD#$BASE_PATH}'$COff'-'$GIT_REPO_NAME'-'$Red'$(git_unpushed_commits_number)$(git_is_uncommited_changes)'$COff'\$ '
	#fi
}

find_base() {
        local CUR_BASE=$PWD
        local CONT=1

        while [[ ! -z "$CUR_BASE" && ! -e $CUR_BASE/$DEV_BASE_ITEM ]]; do
                local CUR_BASE=${PWD%/*}
                cd ..
        done

        [ -z "$CUR_BASE" ] && return 0
}

is_exit_mode() {
	local CURR=${PWD#$BASE_PATH}
	if [ "$PWD" == "$BACK_BASE" ]; then
		mode_exit
	fi
}

mode_exit() {
	CURRENT_SHELL_MODE=""

	echo "Restoring prompt"
	export PS1=$OLD_PS1

	echo "Removing paths"
	export PATH=$OLD_PATH
}

export PROMPT_COMMAND="mode_chk"
