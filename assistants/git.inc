
[ -z "$(which git)" ] && return 1

# If git repo return 0 else 1
is_git_repo() {
  [ -e .git ] && return 0
  echo "No git repository here"
  return 1
}

git_log() {
  #is_git_repo;  (( $? )) && return 1
  git log --graph --decorate --pretty="format:%C(bold blue)%h%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset) %C(auto)%d" $@
}

git_logx() {
  #is_git_repo;  (( $? )) && return 1
  git log --graph --abbrev-commit --decorate --pretty="format:%C(bold blue)%h%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset) %C(auto)%d %C(bold green)(%ar)%C(reset)" $@
}

git_logx_all() {
  git_logx --all
}

git_log_alt() {
  git log --branches --not --remotes --simplify-by-decoration --decorate --oneline
}

git_branch() {
  #is_git_repo;  (( $? )) && return 1
  git branch
}

git_branch_extend() {
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
#  git name-rev --name-only HEAD
#}

git_repo_name() {
  local REMOTES=$(git remote -v)
  #readarray -t REMOTES <<< "$REMOTES"
  for REMOTE in "$REMOTES"; do
    [[ "$REMOTE" =~ "(fetch)" ]] && local REMOTE_URL=${REMOTE%% (fetch)*}
  done

  # Cleaning
  local REMOTE_REPO_NAME=${REMOTE_URL}
  REMOTE_REPO_NAME=${REMOTE_REPO_NAME%\/}
  REMOTE_REPO_NAME=${REMOTE_REPO_NAME%.git}
  REMOTE_REPO_NAME=${REMOTE_REPO_NAME##*/}

  echo $REMOTE_REPO_NAME
}

git_stash_check() {
  [ -z "$(git stash list 2>/dev/null)" ]
}

git_stash_abbrev() {
  if ! git_stash_check; then
    echo S
  fi
}

git_recursive_status() {
  find ./ -name .git -printf "%h\n" -execdir git status --short \;
}

git_prune_by_merged() {
  echo "This is deprecated, use 'git_prune'"
  (
    set -e
    git checkout master &> /dev/null

    local LIST0=($(git branch --merged | grep -v '^* master$' | tr -d '\n'))
    local LIST1=($(git branch --no-merged | grep -v '^* master$' | tr -d '\n'))

    if [ ${#LIST0[@]} -ne 0 -o ${#LIST1[@]} -ne 0 ]; then
      echo "git checkout master &> /dev/null"

      if [ ${#LIST0[@]} -ne 0 ]; then
        printf "git branch -d %s\n" "${LIST0[@]}"
      fi

      if [ ${#LIST1[@]} -ne 0 ]; then
        printf "git branch -D %s\n" "${LIST1[@]}"
      fi

      echo "git checkout - &> /dev/null"
    fi

    git checkout - &> /dev/null
  )
}

git_prune() {
  (
    set -e

    local LIST_GONE=($(git branch -vv | sed 's/^..//' | grep "gone]" | sed 's/ .*//'))

    if [ ${#LIST_GONE[@]} -ne 0 ]; then
      printf "git branch -D %s\n" "${LIST_GONE[@]}"
    fi
  )
}

git_branch_find() {
  git branch --all | grep $1
}

git_alias_install() {
  git config --global alias.co checkout
  git config --global alias.sh stash
}

alias gil='git_log'
alias gill='git_logx'
alias gilll='git_logx_all'
alias gib='git_branch'
alias gibb='git_branch_extend'
alias gis='git_status'
alias girs='git_recursive_status'
alias gia='git add'
alias gic='git commit'
alias gicamend='git commit --amend --no-edit'
alias gitsl='git stash list'
alias gitsd='git stash list'

as_assistant_git() {
  return $?
}
