#!/bin/bash

profile="cscf"

echo -e "Enter the numbers of the machines you wish to redeploy in a space-separated list, or a range (#-#): " 
read names

echo -e "Enter the OS you want to deploy"
read os

if [[ $names == *" "* ]]; then
        echo $names > /tmp/redeploy
        sed -i 's/ /\n/g' /tmp/redeploy 

        input="/tmp/redeploy"
        while IFS= read -r var
        do

                id=$(maas $profile machines read hostname=$var | grep "system_id" | cut -f 4 -d '"' | head -n 1)

                maas $profile machine release $id

                sleep 10

                maas $profile machines allocate system_id=$id

                sleep 10

                maas $profile machine deploy $id distro_series=$os

        done < "$input"

else 
        start=$(echo $names | cut -f 1 -d "-")
        end=$(echo $names | cut -f 2 -d "-")

        for i in $(seq $start $end);
        do

                id=$(maas $profile machines read hostname=obelix$i | grep "system_id" | cut -f 4 -d '"' | head -n 1)

                maas $profile machine release $id

                sleep 10

                maas $profile machines allocate system_id=$id

                sleep 10

                maas $profile machine deploy $id distro_series=$os; done
fi

