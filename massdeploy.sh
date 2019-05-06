#!/bin/bash 

profile="cscf"
maas cscf machines read | jq '.[] | {status_name:.status_name, system_id:.system_id}' --compact-output | grep "Ready" > /tmp/newnodes

input="/tmp/newnodes"
while IFS= read -r var
do

	id=$(echo $var | cut -f 3 -d ":" | grep -E -o [a-zA-Z0-9]+)
	status=$(echo $var | cut -f 2 -d ":" | cut -f 1 -d "," | grep -E -o [a-zA-Z]+)

	if [ "$status" == "Ready" ]; then	

		maas $profile machines allocate system_id=$id
        	sleep 5
        	iface_id=$(maas $profile interfaces read $id | jq ".[] | {iface_id:.id, name:.name}" --compact-output | grep eno1 | cut -f 2 -d ":" | cut -f 1 -d ",")
        	maas $profile interfaces read $id | jq '.[] | .links[] | {link_id:.id, mode:.mode, ipaddr:.ip_address}' --compact-output | grep "auto" | cut -f 2 -d ":" | cut -f 1 -d "," > /tmp/links
        	
		linkinput="/tmp/links"
		while IFS1= read -r linkvar
		do

			maas $profile interface unlink-subnet $id $iface_id id=$linkvar
        	
		done < "$linkinput"

		n=$(maas $profile node power-parameters $id | grep power_a | cut -f 4 -d "." | grep -o -E [0-9]+)
        	maas $profile interface link-subnet $id $iface_id mode=STATIC subnet=192.168.245.0/24 ip_address=192.168.245.$n
        	maas $profile machine update $id hostname=obelix$n domain=cscf.edu
        	maas $profile machine deploy $id distro_series=bionic
	fi
done < "$input"

rm /tmp/newnodes
