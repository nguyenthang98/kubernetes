#!/bin/bash

function log() {
	echo -e "\e[93m$@\e[0m"
}

log '[TASK 1] bootstraping master node'
if [ $1 -eq 1 ]; then
    su - vagrant -c "docker swarm init --advertise-addr $( getent hosts $(hostname) | tail -n 1 | awk '{print $1}' )"
else
    apt-get install -y sshpass >/dev/null 2>&1
    sshpass -p "swarmadmin" ssh -o StrictHostKeyChecking=no swarm-master-1 docker swarm join-token manager | grep --color=none "docker swarm join" 2>/dev/null | bash
fi
