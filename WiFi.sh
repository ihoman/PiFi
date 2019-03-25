#!/bin/sh
sudo apt-get update -y # To get the latest package lists
sudo apt-get dist-upgrade -y
sudo apt-get install hostapd isc-dhcp-server iptables-persistent -y 
sudo sed -i 's/INTERFACES=""/INTERFACES="wlan0"/g' /etc/default/isc-dhcp-server
sudo echo "iface wlan0 inet static" >>  /etc/network/interfaces
sudo echo "address 192.168.1.1" >>  /etc/network/interfaces
sudo echo "netmask 255.255.255.0" >>  /etc/network/interfaces
wget https://learn.adafruit.com/pages/1955/elements/2815040/download -O 
sudo sed -i 's/#DAEMON_CONF=""/DAEMON_CONF="/etc/hostapd/hostapd.conf"/g'  /etc/default/hostapd

sudo sed -i 's/DAEMON_CONF=/DAEMON_CONF=/etc/hostapd/hostapd.conf"/g'  /etc/init.d/hostapd
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo sh -c "iptables-save > /etc/iptables/rules.v4"
sudo /usr/sbin/hostapd /etc/hostapd/hostapd.conf