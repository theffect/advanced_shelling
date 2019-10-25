

source /etc/advanced_shelling/config.inc
source /usr/sbin/advanced_shelling/installation.inc

#BASE_ITEM
[ ! -e "$ASSISTANTS_DIR" ] && \
  echo -e "Asistants scripts directory doesn't exist in path given.\n"\
  "Please check ASSISTANTS_DIR value." && \
  return 1

Red="\[\e[1;31m\]"
Yellow="\[\e[1;33m\]"
Blue="\[\e[1;34m\]"
Pink="\[\e[1;35m\]"
COff="\[\e[m\]"

# Title
TOn="\033]2;"
TOff="\007"


PS1_END='$ '

mode_chk() {
  
  # Already in a mode
  if [ ! -z "$CURRENT_SHELL_MODE" ]; then
    
    is_in_dir
    
    if [ $? -eq 0 ]; then
    
      sub_mode_chk
      [ $? -ne 0 ] && can mode teardown
    
    else
    
      can mode teardown
    
    fi
    
    return 0
  fi

  can mode setup
  unset mode #mode.setup mode.teardown

  return 0
}

can() {
  
  mode() {
    
    mode.make() {
      
      # Adding to current directory the 'base' file,
      #  marking the base directory to run the advanced shelling
      #  mode.
      cp $INSTALL_DIR/$BASE_ITEM.sample ./$BASE_ITEM
      echo "Added \"$BASE_ITEM\" file to current directory"
      
      # Recommending to user to add ignore to base file
      [ -d '.git' ] && \
        echo "Please add \"$BASE_ITEM\" to .gitignore"
        echo "echo \"$BASE_ITEM\" >> .gitignore"
      
    }
    
    # Set the AS mode up
    mode.setup() {
      # No new mode is required
      find_item $BASE_ITEM || return
      
      # Load mode variables
      BASE_ITEM_PATH=$ITEM_PATH
      if [ -f $BASE_ITEM_PATH ]; then
        source $BASE_ITEM_PATH
      else
        return 0
      fi
      
      # User setup function
      if [ "$(type -t setup)" == "function" ]; then
        setup
      fi
      
      
      CURRENT_SHELL_MODE=$SHELL_MODE
      export OLD_PS1=$PS1
      export OLD_PATH=$PATH
      
      export BASE_PATH=${BASE_ITEM_PATH%/*}
      export BACK_PATH=${BASE_PATH%/*}
      
      add_paths
      
      PS1_TITLE=${TOn}$TITLE$TOff
      
      if [ $VAR_LENGTH_LINE -eq 1 ]; then
        #PS1='\[\e]0;  \a\]\u@\h:\w'$PS2_END
        LINE0=\#$Yellow'${PWD#$BACK_PATH}'$COff
        LINE1=$PS1
        #PS1=$PS1_TITLE$LINE0'\n'$LINE1$PS1_END
        PS1=$PS1_TITLE$LINE0'\n'$LINE1
      else
        PS1=$PS1_TITLE'\u@\h:'
        #PS1=${PS1}$Yellow'${PWD#$BACK_PATH}'$COff$PS1_END
        PS1=${PS1}$Yellow'${PWD#$BACK_PATH}'$COff
      fi
      
      export PS1
      export BASE_PS1=$PS1
    
      sub_mode_chk
    
    }


    mode.teardown() {
      CURRENT_SHELL_MODE=""
    
      echo "Restoring prompt"
      export PS1=$OLD_PS1
      unset OLD_PS1
    
      echo "Removing paths"
      export PATH=$OLD_PATH
      unset OLD_PATH
      
      unset BASE_PATH
      unset BACK_PATH
      
      # User teardown function
      source $BASE_ITEM_PATH
      if [ "$(type -t teardown)" == "function" ]; then
        teardown
      fi
    
      unset-variables
      
      return 0
    }


    mode.$@

    unset -f mode.make \
      mode.setup mode.teardown
  }
  
  assistant() {
    
    load() {
      local ASSISTANT=$ASSISTANTS_DIR/$1.inc
      
      [ ! -e $ASSISTANT ] && return 1
      source $ASSISTANT
      
      # A flag like for assistant
      eval "as_assistant_$1 () { return 0; };"
    }
    
    check() {
      
      as_assistant_$1 2> /dev/null
      
      return $?
    }
    
    $@
  }
  
  $@
}

sub_mode_chk() {

  find_item $MODE_GIT_ITEM
  sub_mode_chk_git
  #[ ! -e $MODE_GIT_ITEM ] && return 1
  return 0
}

sub_mode_chk_git() {
  
  RET=$?
  
  if [ $RET -eq 0 ] ; then
    
    can assistant check git
    [ $? -ne 0 ] && can assistant load git
    
    [ $RET -eq 0 ] && mode_git_PS1
    [ $RET -ne 0 ] && umode_git_PS1
    
  else
    
    git rev-parse --git-dir &> /dev/null
    [ $? -ne 0 ] && umode_git_PS1
    
  fi
  
}

mode_git_PS1() {
  local GIT_REPO_NAME="$Blue$(git_repo_name)$COff"
  GIT_PS1='-'$GIT_REPO_NAME'-$(git_branch_name 2>/dev/null)-'$Red'$(git_unpushed_commits_number 2>/dev/null)$(git_is_uncommited_changes 2>/dev/null)'$COff
  if [ $VAR_LENGTH_LINE -eq 1 ]; then
    PS1=$PS1_TITLE$LINE0$GIT_PS1'\n'$LINE1
  else
    PS1=$PS1_TITLE${BASE_PS1%$PS1_END}$GIT_PS1$PS1_END
  fi
}

umode_git_PS1() {
  PS1=${BASE_PS1}
}

add_path() {  
  
  local ADD_PATH=$1
  [[ ! $PATH =~ $ADD_PATH ]] && \
    echo Adding $ADD_PATH to PATH && \
    PATH=$ADD_PATH:$PATH

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
    CUR_BASE=${CUR_BASE%/*}
  done

  [ -z "$CUR_BASE" ] && return 1
  ITEM_PATH=$CUR_BASE/$ITEM
  return 0
}

depth_check() {
  local DEPTH_PWD=$1
  local DEPTH_BASE=$2

  DEPTH_PWD=${DEPTH_PWD//[^/]}
  DEPTH_PWD=${#DEPTH_PWD}

  DEPTH_BASE=${DEPTH_BASE//[^/]}
  DEPTH_BASE=${#DEPTH_BASE}

  if [ $DEPTH_PWD -eq $DEPTH_BASE ]; then
    return 1
  fi

  return 0
}

compare_path() {
  local CUR_PWD=$PWD/
  local CUR_BASE=$BASE_PATH/

  OUTSIDE=0
  while [ -n "$CUR_PWD" -a -n "$CUR_BASE" ]; do
      CUR_PWD=${CUR_PWD#*/}
      CUR_BASE=${CUR_BASE#*/}
	  [ "${CUR_PWD%%/*}" != "${CUR_BASE%%/*}" ] &&
	    OUTSIDE=1 && break
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

unset-variables() {
  unset SHELL_MODE
  unset TITLE
  unset MODE_PATH
  unset MODE_GIT_ITEM
  unset -f mode.setup
  unset -f mode.teardown
}


title() {
    echo -en "\033]2;$1\007"
}

icon_label() {
    echo -en "\033]1;$1\007"
}

###### ( BASH Completion ######

_can_complete() {
  
  local arg=$1
  local cur prev list
  
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}
  
  #echo ${COMP_WORDS[@]}
  FILTER="perl -0777ne"
  
  list="$(declare -f $arg)"
  for NAME in ${COMP_WORDS[@]:0:$COMP_CWORD}; do
    list="$(echo \"$list\" | $FILTER '$_ =~ /(?<funcname>'"$NAME"')\s*\(\)\s*\{(?<content>(?:\{.*\}|[^{])*?)\}/ms; print "$+{content}\n";')"
  done
  
  list="$(echo \"$list\" | $FILTER 'my @m = ($_ =~ /(?<funcname>\w*?)\s*\(\)\s*(\{(?:(?>[^{}]+)|(?2))*?\})/msg); for (my $e; $e < $#m; $e = $e + 2) { print $m[$e]." " };')"
  
  COMPREPLY=($(compgen -W "$list" ${cur}))
}

###### ) BASH Completion ######

complete -F _can_complete can

export PROMPT_COMMAND="mode_chk || unset PROMPT_COMMAND"
