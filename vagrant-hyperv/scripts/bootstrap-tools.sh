#!/bin/bash

function log() {
	echo -e "\e[93m$@\e[0m"
}

log '[TASK 1] update host file'
cat >>/etc/hosts<<EOF
192.168.100.10 hyperv-master
EOF
for i in $(eval echo {1..$1}); do
	echo "192.168.100.2$i hyperv-worker-$i" >>/etc/hosts
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

log '[TASK 3] turning swapoff'
sed -i '/swap/d' /etc/fstab
swapoff -a

log '[TASK 4] add sysctl settings'
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

log '[TASK 5] install kubelet kubadm kubectrl'
apt-get update && apt-get install -y apt-transport-https curl >/dev/null 2>&1
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - >/dev/null 2>&1
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y kubelet kubeadm kubectl >/dev/null 2>&1
sudo apt-mark hold kubelet kubeadm kubectl >/dev/null 2>&1

log '[TASK 6] setting root password'
echo "root:kubeadmin" | sudo chpasswd >/dev/null 2>&1
