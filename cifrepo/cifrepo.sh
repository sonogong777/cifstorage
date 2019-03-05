#!/bin/bash
#
# version 1.0
# krhee@synamedia.com
#
# 1. extract the files onto /home/v2pc/
#
cd /home/v2pc/
echo "extracting cif.repo.tgz to /home/v2pc/cif/"
tar xzvf cif.repo.tgz
echo "creating link in v2pc repo"
ln -s /home/v2pc/cif /var/www/html/cisco/cif
echo "creat link for storage.tgz"
mmkdir -p /var/www/html/cisco/storage/
ln -s /home/v2pc/storage.tgz /var/www/html/cisco/storage/
echo "checking yum repo image"
curl localhost:/cisco/cif/|grep fuse-convmvfs && echo "image posted" || echo "Check link"
curl localhost:/cisco/storage/

