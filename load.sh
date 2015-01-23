
DEV_SCRIPTS="dev_scripts"
DEV_BASE_ITEM=".git"

BASE_PATH=$PWD
BACK_BASE=${PWD%/*}
DEV_PATH=$BASE_PATH/$DEV_SCRIPTS

path_base() {
	local CURR=${PWD#$BASE_PATH}
	if [ "$PWD" == "$BACK_BASE" ] ; then
		echo $PWD
	else
		echo -en "\e[1;33m${CURR#/}\e[m"
	fi
}

repo_name() {
	local CUR_BASE=$PWD
	local CONT=1
	
	while [[ ! -z "$CUR_BASE" && ! -e $CUR_BASE/$DEV_BASE_ITEM ]]; do
		local CUR_BASE=${PWD%/*}
		cd ..
	done
	
	[ -z "$CUR_BASE" ] && return 0
	
	local TMP=$(grep url $CUR_BASE/$DEV_BASE_ITEM/config)
	echo ${TMP##*/}
	#${CUR_BASE##*/}
}

[[ ! $PATH =~ $DEV_SCRIPTS ]] && echo Adding $DEV_PATH to PATH && export PATH=$DEV_PATH:$PATH

export PS1='\u@\h:$(path_base)-\e[1;34m$(repo_name)\e[m\$ '
