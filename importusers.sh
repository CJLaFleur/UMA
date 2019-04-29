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
 ipa user-add $uname --homedir=/mnt/nfs/users/$uname --first=$f --last=$l --displayname=$uname --shell=$shell --gidnumber=$gid --noprivate
 ipa group-add-member $gname --users=$uname 
done < "$input"

