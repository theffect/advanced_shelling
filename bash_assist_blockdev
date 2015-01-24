
[ -z "$(which pbzip2)" ] 	&& return 1
[ -z "$(which dd)" ] 		&& return 2

image2disk() {
    FILE=$1
    BLOCK=$2

    pbzip2 -dc $FILE | dd of=$BLOCK bs=16M

    return $?
}

disk2image() {
    BLOCK=$1
    FILE=$2

    dd if=$BLOCK bs=16M | pbzip2 -c > $FILE

    return $?
}


