
[ -z "$(which vim)" ]  && exit 1

vim_set_defaults() {
	cp $AS_ASSISTANTS_DIR/vim.inc.d/.vimrc ~/
}
