#!/bin/bash

> stat

date=$(date "+%d/%b/%Y:")
hour=$(date "+%H")
let "hour=$hour-1"
if [ ${hour} -lt 10 ]
then
        hour="0${hour}"
fi
date="${date}${hour}"
get=$(grep -e "${date}:" "/var/log/apache2/access.log")

for i in $(seq 1 $(echo "$get" | wc -l))
do
        ip=$(echo "$get" | head -n $i | tail -n 1 | cut -d ' ' -f2)
        pays=$(curl -s "http://ip-api.com/csv/$ip" | cut -d ',' -f2 | tr -d '"')
        heure=$(echo "$get" | head -n $i | tail -n 1 | cut -d ':' -f3-5 | cut -c-8)
        status=$(echo "$get" | head -n $i | tail -n 1 | cut -d ' ' -f10)
        tot[$i]="${ip}, ${pays}, ${heure}, ${status};"
        echo "${tot[$i]}" >> /var/log/apache2/recupip.csv
done