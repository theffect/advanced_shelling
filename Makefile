
install_dir = /usr/sbin/advanced_shelling
config_dir = /etc/advanced_shelling


install:
	[ ! -e $(install_dir) ] && mkdir $(install_dir) || return 0
	[ ! -e $(install_dir) ] && return 1 || return 0
	
	cp -r installation.inc base.sample config.inc.sample load.sh assistants $(install_dir)
	
	[ ! -e $(config_dir) ] && mkdir $(config_dir) || return 0
	[ ! -e $(config_dir) ] && return 1 || return 0
	cp $(install_dir)/config.inc.sample $(config_dir)/config.inc
	
	./Makefile_bashrc.sh install
	

uninstall:
	rm -Rf $(install_dir)
	./Makefile_bashrc.sh uninstall
