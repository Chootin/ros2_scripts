#! /bin/bash

# This script will block all traffic on your ROS_DOMAIN_ID from entering or leaving your system.
# Interface refers to your network interface (e.g. eth0). List these with `ifconfig`.
#
# Author: Alec Tutin
# Date:   2023-06-14

if [ $# != 2 ]; then
	echo "Usage: ros2_secure [interface] [add|remove]"
	exit 0
fi

domain_id=$ROS_DOMAIN_ID
interface=$1

if [ -z "$domain_id" ]; then
	domain_id=0
fi

multicast_start=$((7400 + $domain_id * 250))
multicast_end=$((multicast_start + 1))
unicast_start=$(($multicast_start + 10))
unicast_end=$((unicast_start + 239))

intention="Blocking"
instruction="A"

if [ $2 == "remove" ]; then
	intention="Allowing"
	instruction="D"
fi

echo "$intention all traffic on interface $interface: multicast ports $multicast_start:$multicast_end"
echo "$intention all traffic on interface $interface: unicast ports $unicast_start:$unicast_end"

sudo iptables -$instruction INPUT -i eno1 -p udp --match multiport --dports $multicast_start:$multicast_end -j REJECT
sudo iptables -$instruction OUTPUT -o eno1 -p udp --match multiport --dports $multicast_start:$multicast_end -j REJECT
sudo iptables -$instruction INPUT -i eno1 -p udp --match multiport --dports $unicast_start:$unicast_end -j REJECT
sudo iptables -$instruction OUTPUT -o eno1 -p udp --match multiport --dports $unicast_start:$unicast_end -j REJECT
