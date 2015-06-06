
[ -z "$(which wget)" ] && exit 1

wget_site() {
	
	# -r - Recursive download of the website link tree
	# -p - Download all the elements needed to view the site correctly (localy)
	# -k - Changes the paths of the html links to local locations

	wget -r -p -k $1
}
