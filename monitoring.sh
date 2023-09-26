# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mguardia <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/09/26 16:50:10 by mguardia          #+#    #+#              #
#    Updated: 2023/09/26 19:43:15 by mguardia         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

# ARCHITECTURE
arq=$(uname -a)

#CPU PHYSICAL
cpu=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)

#CPU VIRTUAL
vcpu=$(grep "processor" /proc/cpuinfo | uniq | wc -l)

#RAM
totalram=$(free -m | grep Mem | awk '{print $2}')
usedram=$(free -m | grep Mem | awk '{print $3}')
rampercentage=$(printf "%.2f" $(($usedram * 100 / $totalram))) #Cociente con dos decimales

#DISK
totaldisk=$(df -h --total | grep total | awk '{print $2}')
diskusage=$(df -h --total | grep total | awk '{print $3}' | tr -d 'G')
diskpercentage=$(df -h --total | grep total | awk '{print $5}')

#CPU LOAD
cpuload=$(top -bn1 | grep %Cpu\(s\): | awk '{printf("%.2f", $2+$4)}')

#LAST BOOT
lastboot=$(who -b | sed 's/ *system boot//')

#LVM USE
if [ $(lsblk | grep lvm | wc -l) -gt 0 ]; then
	lvm="YES";
else
	lvm="NO"
fi

#TCP CONNECTIONS
tcp=$(ss -s | grep TCP: | awk '{print $4}' | tr -d ',')

#USER LOG
users=$(users | wc -w)

#NETWORK
ip=$(hostname -I)
macaddress=$(ip a | grep link/ether | tr -d ' ' | sed s'/link\/ether//' | sed s'/brd.*//')

#SUDO
numbersudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "# Architecture: $arq
# CPU physical: $cpu
# vCPU: $vcpu
# Memory Usage: $usedram/${totalram}MB ($rampercentage%)
# Disk Usage: $diskusage/${totaldisk} ($diskpercentage)
# CPU load: $cpuload%
# Last boot: $lastboot
# LVM use: $lvm
# Connexions TCP: $tcp ESTABLISHED
# User log: $users
# Network: IP $ip ($macaddress)
# Sudo: $numbersudo cmd"
