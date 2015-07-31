
[ -z "$(which dd)" ]  && exit 1

dd_size() {
	dd iflags=count_bytes bs=16M
}
