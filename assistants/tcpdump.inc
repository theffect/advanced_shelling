
[ -z "$(which tcpdump)" ] && exit 1

alias netdump="tcpdump -nne -i "
