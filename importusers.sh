#!/bin/bash

input="/root/obelixusers"
while IFS= read -r var
do
 uname="$(echo "$var" | cut -f1 -d ":")"
 uid="$(echo "$var" | cut -f3 -d ":")"
 gid="$(echo "$var" | cut -f4 -d ":")"
 fullname="$(echo "$var" | cut -f5 -d ":" | cut -f1 -d ",")"
 shell="$(echo "$var" | cut -f7 -d ":")"
 f="$(echo $fullname | cut -f1 -d " ")"
 l="$(echo $fullname | cut -f2 -d " ")"
 gname="$(ipa group-find --gid=$gid | grep "Group name:" | cut -f 5 -d " ")"
 
 mkdir /mnt/nfs/users/$uname
 ipa user-add $uname --homedir=/mnt/nfs/users/$uname --first=$f --last=$l --displayname=$uname --shell=$shell --gidnumber=$gid --noprivate
 ipa group-add-member $gname --users=$uname
 mkdir /mnt/nfs/users/$uname/.ssh
 ssh-keygen -t rsa -N "" -C "$uname@obelixmgmt" -f /mnt/nfs/users/$uname/.ssh/id_rsa
 sshkey="$(cat /mnt/nfs/users/$uname/.ssh/id_rsa.pub)"
 ipa user-mod $uname --sshpubkey="$(echo $sshkey)"

 chown -R $uname /mnt/nfs/users/$uname
done < "$input"
