# cifstorage 
# krhee@synamedia.com
# Enable CIFS for media source.
#


Workaround to support CIFS in VOD workflow.
1. Post cifis yum repo and storage.tgz  on v2pc repo
2. Install required packages on the packagers
   a. cif-utils
   b. storage.service package
3. Deploy services.

REQUIREMENTS:
------------
+ Copy following files to site:
  REPO NODE: 
   + cifrepo.sh
   + cif.repo.tgz
   + storage.tgz
  V2PC MASTER:
   + cifrepo.sh  

PREWORK:
-----
 Create workflow "vod-wf-2"
 mediasource "nfs" "/mnt/cif"
 NAS Storage "nfs" "/nfsshare"

WORKFLOW:
--------
1. Identify the target VOD MCE packager
2. Execute first.sh with the following site information or update the cifrepo.sh with site information:
   Usage: ./first.sh <cif server> <user> <password> <cif directory> <VOD MCE name>
   Example: ./first.sh 10.127.208.157 root cisco cif CE-VOD

2. scp cifrepo.repo.tgz to v2pc repo.
3. execute /home/v2pc/cifrepo.sh to create links.
4. execute /root/cifsetup.sh.
5. Enable workflow confirm the /media directories being mount.
6. node service is managed through systemd.
   + systemctl status storage.service


