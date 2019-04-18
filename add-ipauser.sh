#!/bin/bash

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

if [ $usrcount -gt 0 ]; then

        ipa user-add $x$usrcount --homedir=/mnt/nfs/users/$x$usrcount --first=$f --last=$l --displayname=$x$usrcount --shell=/bin/bash

        mkdir /mnt/nfs/users/$x$usrcount

        chown $x$usrcount /mnt/nfs/users/$x$usrcount


else

    	ipa user-add $x --homedir=/mnt/nfs/users/$x --first=$f --last=$l --displayname=$x --shell=/bin/bash

        mkdir /mnt/nfs/users/$x

        chown $x /mnt/nfs/users/$x

fi
