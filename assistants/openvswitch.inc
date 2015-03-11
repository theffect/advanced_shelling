
[ -z "$(which ovs-vsctl)" ] && exit 1
[ -z "$(which ovs-ofctl)" ] && exit 1

alias svs="ovs-vsctl"
alias sof="ovs-ofctl"
