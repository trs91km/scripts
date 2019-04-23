#!/bin/bash
PATH=/ftp/tvn/idemand4uingest/BackupADIFile
Folders=(`/bin/ls -l /ftp/tvn/idemand4uingest/BackupADIFile | /bin/grep ^d | /bin/awk '{print $9}' | /usr/bin/tr '\n' ' '`)
for folder in ${Folders[@]}
do
cd $PATH
/bin/rm -f $folder/file2_$folder.txt
/bin/touch $folder/file2_$folder.txt
echo "$folder/file2_$folder.txt created"
echo "#This file was created by automated script for.sh" > $folder/file2_$folder.txt
/bin/cat $folder/file2_$folder.txt
done
