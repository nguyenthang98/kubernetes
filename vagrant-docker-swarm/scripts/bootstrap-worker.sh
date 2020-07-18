#!/bin/bash

function log() {
	echo -e "\e[93m$@\e[0m"
}

log "[TASK 1] Join node to kubernetes cluster"
apt-get install -y sshpass >/dev/null 2>&1
sshpass -p "swarmadmin" ssh -o StrictHostKeyChecking=no swarm-master-1 docker swarm join-token worker | grep --color=none "docker swarm join" 2>/dev/null | bash
