

source /etc/advanced_shelling/config.inc
source /usr/sbin/advanced_shelling/installation.inc

#BASE_ITEM
[ ! -e "$ASSISTANTS_DIR" ] && echo -e "Asistants scripts directory doesn't exist in path given.\n""Please check ASSISTANTS_DIR value." && return 1

Red="\[\e[1;31m\]"
Yellow="\[\e[1;33m\]"
Blue="\[\e[1;34m\]"
Pink="\[\e[1;35m\]"
COff="\[\e[m\]"

PS1_END='$ '

mode_chk() {
	
	# Already in a mode
	if [ ! -z "$CURRENT_SHELL_MODE" ]; then
		is_in_dir
		if [ $? -eq 0 ]; then
			find_item $MODE_ITEM
			if [ $? -eq 0 ] ; then
				as_check_assistant git
				[ $? -ne 0 ] && load_assitant git

				mode_git_PS1
			else
				umode_git_PS1
			fi
		else
			mode_exit
		fi
		
		return
	fi
	
	# No new mode is required
	find_item $BASE_ITEM || return
	
	# Load mode variables
	BASE_ITEM_PATH=$ITEM_PATH
	source $BASE_ITEM_PATH
	
	export CURRENT_SHELL_MODE=$SHELL_MODE
	export OLD_PS1=$PS1
	export OLD_PATH=$PATH
	
	export BASE_PATH=${BASE_ITEM_PATH%/*}
	export BACK_PATH=${BASE_PATH%/*}
	
	add_paths
	
	if [ $VAR_LENGTH_LINE -eq 1 ]; then
		PS1='\u@\h:\w'$PS1_END
		LINE0=\#$Yellow'${PWD#$BACK_PATH}'$COff
		LINE1=$PS1$PS1_END
		PS1=$LINE0'\n'$LINE1
	else
		PS1='\u@\h:'
		PS1=${PS1}$Yellow'${PWD#$BACK_PATH}'$COff$PS1_END
	fi
	
	export PS1
	export BASE_PS1=$PS1

	load_assitant git
	[ -e $MODE_ITEM ] && mode_git_PS1
}

mode_make() {
	cp $INSTALL_DIR/$BASE_ITEM.sample ./$BASE_ITEM
}

as_check_assistant() {
	as_assistant_$1 2> /dev/null
	return $?
}

load_assitant() {
	local ASSISTANT=$ASSISTANTS_DIR/$1.inc
	[ ! -e $ASSISTANT ] && return 1
	source $ASSISTANT
	
	# A flag like for assistant
	eval "as_assistant_$1 () { return 0; };"
}

mode_git_PS1() {
	local GIT_REPO_NAME="$Blue$(git_repo_name)$COff"
	GIT_PS1='-'$GIT_REPO_NAME'-$(git_branch_name)-'$Red'$(git_unpushed_commits_number)$(git_is_uncommited_changes)'$COff
	if [ $VAR_LENGTH_LINE -eq 1 ]; then
		PS1=$LINE0$GIT_PS1'\n'$LINE1
	else
		PS1=${BASE_PS1%$PS1_END}$GIT_PS1$PS1_END
	fi
}

umode_git_PS1() {
	PS1=${BASE_PS1}
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

find_item() {
	local ITEM=$1
	
	local CUR_BASE=$PWD
	local CONT=1

	while [[ ! -z "$CUR_BASE" && ! -e $CUR_BASE/$ITEM ]]; do
		local CUR_BASE=${CUR_BASE%/*}
	done

	[ -z "$CUR_BASE" ] && return 1
	ITEM_PATH=$CUR_BASE/$ITEM
	return 0
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

is_in_dir() {
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
