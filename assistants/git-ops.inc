
git-merge-clean() {
  find ./ -name '*.orig' -exec rm {} \;
  find ./ -regex '.*_\(BACKUP\|BASE\|LOCAL\|REMOTE\)_[0123456789]+.*' -exec rm {} \;
}

