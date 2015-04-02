
[ -z "$(which ps)" ] && exit 1

pst() {
    ps H -eo pid,tid,class,cgroup,rtprio,ni,pri,blocked,psr,pcpu,stat,wchan:20,command,comm
}
