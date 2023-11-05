#!/bin/bash

architecture=$(uname -a)
cpu_physical=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l) 
virtual_cpu=$(grep "^processor" /proc/cpuinfo | wc -l)
free_ram=$(free -m | awk '$1 == "Mem:" {print $2}')
used_ram=$(free -m | awk '$1 == "Mem:" {print $3}')
percent_ram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
total_disk=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
used_disk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
percent_disk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
cpu_load=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
last_boot=$(date -d "$(uptime -s)" +'%Y-%m-%d %H:%M')
lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
connections_tcp=$(ss -neopt state established | wc -l)
user_log=$(users | wc -w)
ip=$(hostname -I | awk '{print $1}')
mac=$(ip link show | grep "ether" | awk '{print $2}')
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

echo "  #Architecture: $architecture" 
echo "  #CPU physical: $cpu_physical"
echo "  #vCPU: $virtual_cpu"
echo "  #Memory Usage: $used_ram/${free_ram}MB ($percent_ram%)"
echo "  #Disk Usage: $used_disk/${total_disk}Gb ($percent_disk%)"
echo "  #CPU load: $cpu_load"
echo "  #Last boot: $last_boot"
echo "  #LVM use: $lvm"
echo "  #Connections TCP: $connections_tcp ESTABLISHED"
echo "  #User log: $user_log"
echo "  #Network: IP $ip ($mac)"
echo "  #Sudo: $cmds cmd"