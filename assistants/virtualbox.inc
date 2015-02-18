
[ ! -z "$(which vboxmanage)" ] && return 1

vb_snapshot_to_() {
    snapshot_uuid=$1
    target_path=$2
    format=$3

    vboxmanage clonehd $snapshot_uuid $target_path/current.raw -format $format
}

vb_to_raw() {
    input=$1
    output=$2

    vboxmanage internalcommands converttoraw $input $output
}
