#!/bin/bash



function _ssh {

USER=$1
HOST=$2
PWD=$3

/usr/bin/expect <<- EOD

#	log_file input=/home/asad/Autologin/ssh_tmp.log

	set timeout  30
	log_user  1
	set send_slow {1 .01}

	send_log  "Connecting to $HOST using $USER user\n"
	eval spawn ssh-copy-id -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o Connecttimeout=30 "$USER\@$HOST"
	expect  {
        	timeout       { send_user  "timeout  while connecting to $HOST\n"; exit }
        	"*No route to host*" { send_user  "$HOST not reachable\n"; exit }
        	"*assword: " { send -s $PWD\r }
        	}
	expect  {
        	timeout  { send_user  "timeout  waiting for prompt\n"; exit }
        	"*]#"   { send_user  "Login successful to $HOST\n" }
        	}
#	send "hostname\r"
#		expect  {
#        	"*]#"   { send "exit\r" }
#        	}
	send_user  "Disconnected\n"
#	close

EOD
}





input=/home/asad/Autologin/machine.txt
while IFS= read -r line
do
  echo "$line"
  _ssh root $line letmein
done < "$input"
