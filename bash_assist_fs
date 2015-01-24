[ -z "$(which dd)" ] && return 1

fill_zero() {
        FILE=$1

        dd if=/dev/zero of=$FILE bs=16M
        rm $FILE
        
        return $?
}
