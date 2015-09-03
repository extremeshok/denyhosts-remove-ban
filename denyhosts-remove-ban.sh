#!/bin/bash
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Denyhosts IP Remove Ban / Unban Script
# Version 2.0
# 03 September 2015
# Copyright (c) Adrian Jon Kriel : root-at-extremecooling-dot-org
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
####################
#
# Remove Ban / Unban an IP from denyhosts
# Usage: denyhosts-remove-ban.sh <ip-address-to-unban>
#
# Remove Ban of multiple IP addresses
# Usage: denyhosts-remove-ban.sh <ip-1> <ip-2> <ip-3>
#
# Note: 
# restarting the hostsdeny service after running the script is NOT required
#
####################
HOSTSDENYFILE="/etc/hosts.deny"
#WORKDIR="/usr/share/denyhosts/data" #no trailing / .. debian
WORKDIR="/var/lib/denyhosts" #no trailing / ... centos
WORKFILES=("hosts" "hosts-restricted" "hosts-root" "hosts-valid" "users-hosts");

#check there are arguments
if [[ ! "$1" ]]; then
    echo "Usage: ${0##*/} <ip-address-to-unban>";
    echo "Multiple IP: ${0##*/} <ip1> <ip2> <ip3> <ip4>";
	exit
fi

#generate array of files with paths.. this is the *magic*
filelist=($HOSTSDENYFILE)
for file in "${WORKFILES[@]}"
do
	filelist=("${filelist[@]}" "$WORKDIR/$file")
done
for varip in "$@"
do
	if [[ $varip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then	
		for varfile in "${filelist[@]}"
		do	
			if [[ -f "$varfile" ]]; then
				echo "Clearing $varip from $varfile"
				sed -i -e "/$varip/d" $varfile 2>&1
			else
				echo "ERROR: invlaid file $varfile"
			fi
		done
	else
		echo "ERROR: invalid IP $varip";
	fi
done
