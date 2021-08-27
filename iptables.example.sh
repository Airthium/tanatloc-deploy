#!/bin/bash

interface=docker-interface
outinterface=docker-out-interface
dockerip=docker-ip/docker-port

VPN=vpn-ip
allowlist=(
allow-ip-1
allow-ip-2
)

## SSH on VPN only
echo "SSH allow $VPN"
sudo iptables -I INPUT ! -s $VPN -p tcp --dport 22 -j DROP

## Docker access
# Remove old ACCEPT
sudo iptables -D DOCKER -d $dockerip ! -i $interface -o $outinterface -p tcp -m tcp --dport 443 -j ACCEPT
sudo iptables -D DOCKER -d $dockerip ! -i $interface -o $outinterface -p tcp -m tcp --dport 80 -j ACCEPT

# Add new
echo "Allow $VPN"
sudo iptables -A DOCKER -d $dockerip ! -i $interface -o $outinterface -p tcp -m tcp --dport 443 -s $VPN -j ACCEPT
sudo iptables -A DOCKER -d $dockerip ! -i $interface -o $outinterface -p tcp -m tcp --dport 80 -s $VPN -j ACCEPT

for ip in ${allowlist[@]};
do
	echo "Allow $ip"
	sudo iptables -A DOCKER -d $dockerip ! -i $interface -o $outinterface -p tcp -m tcp --dport 443 -s $ip -j ACCEPT
	sudo iptables -A DOCKER -d $dockerip ! -i $interface -o $outinterface -p tcp -m tcp --dport 80 -s $ip -j ACCEPT
done

