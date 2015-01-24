
[ -z "$(which ssh)" ] 		&& return 1
[ -z "$(which ssh-keygen)" ] 	&& return 2
[ -z "$(which ssh-copy-id)" ] 	&& return 3

# Easy ssh connection with no password
addcouple() {
	[ ! -e ~/.ssh/id_rsa.pub ] && ssh-keygen -t rsa
	ssh-copy-id -i
}

ssh_copy_id() {
	cat ~/.ssh/id_rsa.pub | ssh $1 <<< EOF
	chmod 750 .;
	[ ! -d ~/.ssh ] && mkdir ~/.ssh && touch ~/.ssh/authorized_keys;
	chmod 750 ~/.ssh;
	chmod 600 ~/.ssh/authorized_keys;
	cat >> .ssh/authorized_keys'
EOF
}

retry_ssh() {
	REMOTE=$1;
	NUM=$2;
 
	[ -z "$NUM" ] && NUM=10;
 
	while (( 1 )); do
		ssh $REMOTE 2> /dev/null;
		let NUM=$NUM+1;
 
		SLEEP=360;
		while (( $SLEEP )); do
			printf "\rTry %5d, Slept %3d" $NUM $SLEEP;
			let SLEEP=$SLEEP-1;
			sleep 1;
		done;
	done;
}
