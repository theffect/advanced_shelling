
[ -z "$(which ps)" ] && return 1

ps_x() {
    ps xawf -eo pid,user,cgroup,args
}

