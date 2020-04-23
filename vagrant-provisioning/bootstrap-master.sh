#!/bin/bash

function log() {
	echo -e "\e[93m$@\e[0m"
}

log '[TASK 1] bootstraping master node'
kubeadm init --apiserver-advertise-address=172.42.42.100 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

log "[TASK 2] Copy kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube  >/dev/null 2>&1
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config >/dev/null 2>&1
chown -R vagrant:vagrant /home/vagrant/.kube >/dev/null 2>&1

log "[TASK 3] make control plane create container"
su - vagrant -c "kubectl taint nodes --all node-role.kubernetes.io/master-" >/dev/null 2>&1

log "[TASK 4] Deploy kube router"
su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml" >/dev/null 2>&1

log "[TASK 5] Generate and save cluster join command"
kubeadm token create --print-join-command > /joincluster.sh
