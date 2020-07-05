#!/bin/bash

function log() {
	echo -e "\e[93m$@\e[0m"
}

log "[TASK 1] install nfs-kernel-server"
sudo apt update
sudo apt install -y nfs-kernel-server

log "[TASK 2] create nfs export directory"
sudo mkdir -p /mnt/nfs_share
sudo chown -R nobody:nogroup /mnt/nfs_share
sudo chmod 777 /mnt/nfs_share

log "[TASK 3] grant nfs share access to client systems"
cat <<EOF >>/etc/exports
/mnt/nfs_share *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)
EOF

log "[TASK 4] export the nfs share directory"
sudo exportfs -rav
sudo systemctl enable nfs-kernel-server
sudo systemctl restart nfs-kernel-server

