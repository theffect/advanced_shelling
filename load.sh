

BASE_ITEM=.base

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
		
		export BASE_PATH=$PWD
		export BACK_BASE=${PWD%/*}

		
		add_paths 
		export PS1='\u@\h:$(path_base)-\e[1;34m$(git_repo_name)\e[m\$ '
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
		CURRENT_SHELL_MODE=""
		export PS1=$OLD_PS1
	fi
}

path_base() {
	local CURR=${PWD#$BASE_PATH}
	if [ "$PWD" == "$BACK_BASE" ] ; then
		echo $PWD
	else
		echo -en "\e[1;33m${CURR#/}\e[m"
	fi
}

export PROMPT_COMMAND="mode_chk"
