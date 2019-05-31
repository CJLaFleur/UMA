#!/bin/bash
####
# TO DO:
# Implement directory checking so it doesn't try to create another version of an existing directory.
# This script should be converted to Python. Investigate the freeipa Python module at https://pypi.org/project/python-freeipa/
####
echo -e "Enter the full name of the user: "
read fullname

echo -e "Enter the primary user group: "
read group

echo -e "Set the user's password: "
read -s password

x=${fullname:0:1}
x+="$(echo $fullname | cut -f 2 -d " ")"
x="$(echo $x | tr '[:upper:]' '[:lower:]')"
f="$(echo $fullname | cut -f 1 -d " ")"
l="$(echo $fullname | cut -f 2 -d " ")"

usrcount="$(ipa user-find $x | grep -o -E '[0-9]+' | head -1)"

groupid="$(ipa group-find --all | grep "GID" | cut -f 2 -d ":")"

if [ $usrcount -gt 0 ]; then

        ipa user-add $x$usrcount --homedir=/mnt/nfs/users/$x$usrcount --first=$f --last=$l --displayname=$x$usrcount --shell=/bin/bash --gidnumber=$groupid

        mkdir /mnt/nfs/users/$x$usrcount

        mkdir /mnt/nfs/users/$x$usrcount/.ssh

        ssh-keygen -t rsa -N "" -C "$x$usrcount@obelixmgmt" -f /mnt/nfs/users/$x$usrcount/.ssh/id_rsa

        sshkey="$(cat /mnt/nfs/users/$x$usrcount/.ssh/id_rsa.pub)"

        ipa user-mod $x$usrcount --sshpubkey="$(echo $sshkey)"

        chown -R $x$usrcount /mnt/nfs/users/$x$usrcount
        
        echo -e "$secretpass\n$secretpass" | (ipa passwd $x$usrcount)
else

    	ipa user-add $x --homedir=/mnt/nfs/users/$x --first=$f --last=$l --displayname=$x --shell=/bin/bash

        mkdir /mnt/nfs/users/$x

        mkdir /mnt/nfs/users/$x/.ssh

        ssh-keygen -t rsa -N "" -C "$x@obelixmgmt" -f /mnt/nfs/users/$x/.ssh/id_rsa

        sshkey="$(cat /mnt/nfs/users/$x/.ssh/id_rsa.pub)"

        ipa user-mod $x --sshpubkey="$(echo $sshkey)"

        chown -R $x /mnt/nfs/users/$x
        
        echo -e "$secretpass\n$secretpass" | (ipa passwd $x)
fi
