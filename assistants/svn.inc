
_svn-staged-files() {
  local OUTPUT="$(svn status | grep -E '^(M|A|R)')"
  while read -r FILE; do
    echo "${FILE:8}";
  done <<< "$OUTPUT"
}

svn-files-to-commit() {
  echo
  echo "Chosen to commit:"
  local OUTPUT="$(_svn-staged-files)"
  while read -r FILE; do
    echo "  ${FILE}";
  done <<< "$OUTPUT"

  echo
  echo "review to commit:"
  local OUTPUT="$(svn status | grep -E '^(\?|C|I)')"
  while read -r FILE; do
    echo "  ${FILE:8}";
  done <<< "$OUTPUT"
}
