#!/bin/bash
#
#
#
#

usage() {
    echo "Usage: $0 <cif server> <user> <password> <cif directory> <VOD MCE name>"
    echo "Example: $0 10.127.208.157 root cisco cif MCE-VOD"
}

if [ $# -le 3 ];then 
   usage
   exit 1
fi

CIFSERVER="$1"
USER="$2"
PASS="$3"
DIR="$4"
NAME="MCE-VOD"
if [ $# == 5 ];then
    NAME="$5"
fi
echo "Will update the script with the site specific information"
echo "updating cifsetup.sh but feel free to manually update as needed"
cp cifsetup.sh cifsetup.sh.back
sed -i "s/10.127.208.157\/cif/10.127.208.157\/$DIR/g" cifsetup.sh
sed -i "s/10.127.208.157/$CIFSERVER/g" cifsetup.sh
sed -i "s/username\=root/username\=$USER/g" cifsetup.sh
sed -i "s/password\=cisco/password\=$PASS/g" cifsetup.sh
sed -i "s/MCE-VOD-/$NAME/g" cifsetup.sh

echo "creating cifrepo.repo.tgz"
cd ../cifrepo/
tar czvf ../cifrepo.repo.tgz *

echo "scp cifrepo.repo.tgz to repo && extract execute cifrepo.sh"
echo "scp cifsetup.sh to v2pc master "




