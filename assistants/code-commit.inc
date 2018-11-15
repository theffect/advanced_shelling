
#source svn.inc

pre-commit-code-reminders() {
  grep "SZ TODO" ./ -r
}

repo-precommit-code-reminders() {
  for FILE in $(svn-files-to-commit); do
    local OUTPUT=$(svn diff 2>/dev/null | grep -n "SZ TODO")
  done

  echo
  echo "Consider review:"
  echo "  $OUTPUT"

  #git diff 2>/dev/null | grep -n "SZ TODO"
}

pre-commit-reminders() {
  svn-files-to-commit
  repo-precommit-code-reminders
}


