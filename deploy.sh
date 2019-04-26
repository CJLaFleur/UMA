#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

profile=($1)
echo -e "${GREEN}Enter the hostname of the machine you wish to deploy: ${NC}" 
read name
echo -e "${GREEN}Enter the OS you wish to install: ${NC}" 
read os
echo -e "${GREEN}Is the information you entered correct? (y or n): ${NC}" 
read confirm
echo -e "${YELLOW}WARNING: Proceeding further will completely destroy any and all data stored locally on the node.
By proceeding, you accept the responsibility for your actions. (y or n): ${NC}" 
read confirm2

if [ $confirm == "y" ] && [ $confirm2 == "y" ]
then

        id=$(maas $profile machines read hostname=$name | grep "system_id" | cut -f 4 -d '"' | head -n 1)

        maas $profile machines allocate system_id=$id

        sleep 5

        iface_id=$(maas $profile interfaces read $id | jq ".[] | {iface_id:.id, name:.name}" --compact-output | grep eno1 | cut -f 2 -d ":" | cut -f 1 -d ",")

        link_id=$(maas cscf interfaces read $id | jq '.[] | .links[] | {link_id:.id, mode:.mode, ipaddr:.ip_address}' --compact-output | head -n 1 | cut -f 2 -d ":" | cut -f 1 -d "," )

        maas $profile interface unlink-subnet $id $iface_id id=$link_id

        n=$(echo $name | grep -E -o [0-9]+)

        maas $profile interface link-subnet $id $iface_id mode=STATIC subnet=192.168.245.0/24 ip_address=192.168.245.$n

        maas $profile machine deploy $id distro_series=$os

        echo -e "${GREEN}Your machine has been successfully deployed. 
After the machine finishes booting, run the post-install script deploy(osname).sh located in the /maas directory using the following command:
ssh (osname)@ipaddress < deploy(osname).sh${NC}"

fi
