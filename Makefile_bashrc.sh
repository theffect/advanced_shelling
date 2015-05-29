

action=$1
shift

case "$action" in
	install)
		echo "Please add this to the .bashrc file in your home directory."
		cat << EOF
if [ -f /usr/sbin/advanced_shelling/load.sh ]; then
	echo "Using advanced shelling"
	source /usr/sbin/advanced_shelling/load.sh
fi
EOF
	;;
	uninstall)
		echo "Please remove the condition of the \"Advanced Shelling\" from your .bashrc file."
	;;
	*)
		echo "Usage: $0 install/uninstall"
	;;
esac
