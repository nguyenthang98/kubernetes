#!/bin/bash

function log() {
	echo -e "\e[93m$@\e[0m"
}

log "[TASK 1] Join node to kubernetes cluster"
apt-get install -y sshpass >/dev/null 2>&1
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no hyperv-master:/joincluster.sh /joincluster.sh 2>/dev/null
bash /joincluster.sh >/dev/null 2>&1
