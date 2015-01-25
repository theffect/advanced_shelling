

source config.inc

Red="\[\e[1;31m\]"
Yellow="\[\e[1;33m\]"
Blue="\[\e[1;34m\]"
Pink="\[\e[1;35m\]"
COff="\[\e[m\]"

PS1_END='$ '

mode_chk() {
	
	# Already in a mode
	if [ ! -z "$CURRENT_SHELL_MODE" ]; then
		is_in_mode
		if [ $? -eq 0 ]; then
			mode_git_PS1
		else
			mode_exit
		fi
		
		return
	fi
	
	# No new mode is required
	[ ! -e "./$BASE_ITEM" ] && return
	
	# Load mode variables
	source $BASE_ITEM
	
	export CURRENT_SHELL_MODE=$SHELL_MODE
	export OLD_PS1=$PS1
	export OLD_PATH=$PATH
	
	export BASE_PATH=$PWD
	export BACK_PATH=${PWD%/*}
	
	add_paths
	
	export PS1='\u@\h:'$Yellow'${PWD#$BACK_PATH}'$COff$PS1_END
	export BASE_PS1=$PS1
	
	mode_git
	mode_git_PS1
}

mode_git() {
	source $ASSISTANTS_DIR/bash_assist_git 
}

mode_git_PS1() {
	local GIT_REPO_NAME="$Blue$(git_repo_name)$COff"
	PS1=${BASE_PS1%$PS1_END}'-'$GIT_REPO_NAME'-'$Red'$(git_unpushed_commits_number)$(git_is_uncommited_changes)'$COff$PS1_END
}

add_path() {	
	local ADD_PATH=$1
	[[ ! $PATH =~ $ADD_PATH ]] && echo Adding $ADD_PATH to PATH && export PATH=$ADD_PATH:$PATH
}

add_paths() {
	for CUR_PATH in "${MODE_PATH[@]}"; do
		local ADD_PATH=$BASE_PATH/$CUR_PATH
		add_path "$ADD_PATH"
	done
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

compare_path() {
	local CUR_PWD=$PWD/
	local CUR_BASE=$BASE_PATH/

	while [ ! -z "$CUR_PWD" -a ! -z "$CUR_BASE" ]; do
			CUR_PWD=${CUR_PWD#*/}
			CUR_BASE=${CUR_BASE#*/}
			#echo -e "PWD=$CUR_PWD\nBASE=$CUR_BASE"
	done

	# Inside = True
	[ -z "$CUR_BASE" ] && return 0
	
	# Outside = False
	return 1
}

is_in_mode() {
	compare_path
	return $?
}

mode_exit() {
	CURRENT_SHELL_MODE=""

	echo "Restoring prompt"
	export PS1=$OLD_PS1
	unset OLD_PS1

	echo "Removing paths"
	export PATH=$OLD_PATH
	unset OLD_PATH
	
	unset BASE_PATH
	unset BACK_PATH
	
	return 0
}

export PROMPT_COMMAND="mode_chk"
