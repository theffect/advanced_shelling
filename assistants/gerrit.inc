
[ -z "$(which git)" ] && return 1

# Gerrit helpers

#
# Commit 'update' with 'push' to a pull-request for 'master'
#  using the branch name as a topic
#
gerrit-commit-update() {
  local branch
  local state="$1"; shift

  branch="$(git rev-parse --abbrev-ref HEAD)"
  if [ "$branch" == "master" ]; then
    echo "Please branch out to a dev-<feature>" 1>&2
    return 1
  fi

  if [ "$(git rev-parse master)" == "$(git rev-parse HEAD)" ]; then
    echo "Please add a new commit on to $branch" 1>&2
    return 1
  fi

  case "$state" in
    wip|ready) state="%$state" ;;
	"") ;;
	*)
      echo "Use \"wip\" or \"ready\" to specifiy state of push" 1>&2
	  return 1;;
  esac

  git commit --amend --no-edit
  git push origin $branch:refs/for/master$state -o topic="$branch"
}

gerrit-commit-push() {
  local branch
  local state="$1"; shift

  branch="$(git rev-parse --abbrev-ref HEAD)"
  if [ "$branch" == "master" ]; then
    echo "Please branch out to a dev-<feature>" 1>&2
    return 1
  fi

  case "$state" in
    wip|ready) state="%$state" ;;
	"") ;;
	*)
      echo "Use \"wip\" or \"ready\" to specifiy state of push" 1>&2
	  return 1;;
  esac

  git push origin $branch:refs/for/master$state -o topic="$branch"
}

gerrit-commit-merged() {
  local fetched_digest
  local branch_digest branch_name

  git fetch -p

  fetched_digest="$(git rev-parse origin/master)"
  branch_digest="$(git rev-parse HEAD)"
  branch_name="$(git rev-parse --abbrev-ref HEAD)"

  if [ "$fetched_digest" != "$branch_digest" ]; then
    return 0
  fi

  git checkout master
  git merge

  git branch -D $branch_name
}

gerrit-cross-repo-commit-update() {
  local branch="$1"
  for entry in $(find ./ -path '*/.git/refs/heads/'$branch 2>/dev/null); do

    name="${entry%%/.git/*}"
    name="${name#./}"

    if [ "$name" == "." ]; then
      name=${PWD##*/}
    fi

    echo $name
    (cd $name; gcu;)
  done
}

gcrcu() { gerrit-cross-repo-commit-update "$@"; }
gcu() { gerrit-commit-update "$@"; }
gcp() { gerrit-commit-push "$@"; }
gcm() { gerrit-commit-merged "$@"; }

