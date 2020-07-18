#!/bin/bash

function log() {
	echo -e "\e[93m$@\e[0m"
}

log '[TASK 1] update host file'
# cat >>/etc/hosts<<EOF
# 192.168.100.30 swarm-master
# EOF
for i in $(eval echo {1..$2}); do
	echo "192.168.100.3$i swarm-master-$i" >>/etc/hosts
done
for i in $(eval echo {1..$1}); do
	echo "192.168.100.4$i swarm-worker-$i" >>/etc/hosts
done

log '[TASK 2] install docker engine'
apt-get update >/dev/null 2>&1
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common >/dev/null 2>&1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - >/dev/null 2>&1
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" >/dev/null 2>&1
apt-get update >/dev/null 2>&1
apt-get install -y docker-ce docker-ce-cli containerd.io >/dev/null 2>&1

log '[TASK 3] add to docker group'
sudo usermod -aG docker vagrant

log '[TASK 4] setting root password, vagrant password'
echo "root:swarmadmin" | sudo chpasswd >/dev/null 2>&1
echo "vagrant:vagrantadmin" | sudo chpasswd >/dev/null 2>&1
