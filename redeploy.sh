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

	maas $profile machine release $id

        sleep 20

        maas $profile machines allocate system_id=$id

        sleep 5

        maas $profile machine deploy $id distro_series=$os
	
	echo -e "${GREEN}Your machine has been successfully deployed. 
After the machine finishes booting, run the post-install script deploy.sh located in the /maas directory using the following command:
ssh $os@ipaddress < deploy$os.sh${NC}"
fi



