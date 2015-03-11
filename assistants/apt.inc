
[ -z "$(which apt-get)" ] && exit 1

apt_purge() {
    apt-get purge $(dpkg -l | grep ^rc | cut -d" " -f3 | cut -d: -f1)
}

apt_size_sort() {
    for pack in $(cat txt); do echo -en $(dpkg -p $pack | grep ^Size | cut -d" " -f2 | xargs printf %010d) : $pack " \n"; done | sort
}

alias apt-purge="apt-get --purge remove"
