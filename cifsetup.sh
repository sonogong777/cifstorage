#!/bin/bash
#
# krhee@synamedia.com
# Execute this script on target MCE.
# v 1.0
# 

CIFSERVER="10.127.208.157"
salt_cli(){
CLI="$1"
#UPDATE THE FOLLOWING to the target MCE at the site.
salt '*MCE-VOD-[4,6]*' cmd.run "$CLI"
}

echo "Backing up yum.repo"
salt_cli "mv /etc/yum.repos.d/Cent* /etc/yum.repos.d/epel* /root/;cp /etc/yum.repos.d/v2pc.repo /etc/yum.repos.d/cif.repo;ls -al /etc/yum.repos.d/"
echo "Create cif.repo"
salt_cli "sed -i 's/cisco.*\$/cisco\/cif/g' /etc/yum.repos.d/cif.repo;sed -i 's/v2pc/cif/g' /etc/yum.repos.d/cif.repo;grep -e cisco -e cif /etc/yum.repos.d/cif.repo"
echo "Enable cif.repo"
salt_cli "yum-config-manager --enable cif"
echo "Yum install samba samba-client cifs-utils samba-common"
salt_cli "yum install samba samba-client cifs-utils samba-common --skip-broken -y"
echo "Create mount directories: /mnt/cif /nfsshare"
salt_cli "mkdir -p /mnt/cif;mkdir -p /nfsshare;chmod -R 777 /nfsshare;chmod -R 777 /mnt/cif"

#Disable StorageMain ()
echo "Disable Storage"
salt_cli "supervisorctl stop StorageMain"
salt_cli "supervisorctl remove StorageMain"

#CIFS storage configuration 
echo "Mounting cif mount -t cifs -o user=root,password=cisco //$CIFSERVER/cif/samba /mnt/cif"
salt_cli "echo '//10.127.208.157/cif /mnt/cif cifs username=root,password=cisco,soft,rw 0 0' >> /etc/fstab;umount /mnt/cif;mount -a"
salt_cli "echo hello > /mnt/cif/\$(hostname)"

#incase NFS is used for storage..
echo "Mounting nfs 10.127.208.157:/output /nfsshare nfs defaults 0 0"
salt_cli "echo '10.127.208.157:/output /nfsshare nfs defaults 0 0' >> /etc/fstab;umount /nfsshare;mount -a"
salt_cli "echo hello > /nfsshare/\$(hostname)"

echo "Install workaroundi node package"
echo "pulling storage package from repo node"
salt_cli "cd /root;wget http://10.127.208.155/cisco/storage/storage.tgz;ls -al /root/storage.tgz"
echo "extracting storage.tgz to /root/"
#salt_cli "cd /root/;tar xzvf storage.tgz;cd /root/storage/;node fakeSAL2.js > /var/log/node.log 2> /var/log/node-err.log &"
salt_cli "cd /root/;tar xzvf storage.tgz;ls -al /root/storage/"
salt_cli "cp /root/storage/storage.service /lib/systemd/system/storage.service"
salt_cli "systemctl enable storage.service;systemctl start storage.service;sleep 3;systemctl status storage.service"

echo "Please enable workflow"
