#/bin/bash

#Script show open ports 

# My Version

ss -lnupt | awk -F' ' '{ print $5}' | awk -F':' '{print $2}' | awk '{if(NF>0) {print $0}}'

# Teacher version

netstat -nutl | grep ':' | awk '{ print $4}' | awk -F ':' {print $NF}
