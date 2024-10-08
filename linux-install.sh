#!/bin/bash

clear
echo -e "Welcome to the installer, lets get started!\r\n"

## installing git and platformio
read -p "Do we need to install git, build-essentials and platformio? (y/N/s): " option
case $option in
  y)
    sudo apt install git build-essentials platformio
    ;;
  s)
    ;;
  *)
    exit
    ;;
esac


clear
echo -e "now we need to clone the GNATS repo, lets see it if exists first"
if [ -d "GNATS/" ]; then
  read -p "Directory exists, do you want to delete? (y/N): " delete
  if [ $delete = 'y' ]; then
    rm -rf GNATS/
    git clone https://github.com/jeff-comley/GNATS.git
    cd GNATS/
  fi

  else
    git clone https://github.com/jeff-comley/GNATS.git
    cd GNATS/
fi

clear
# are we using Wifi or Ethernet?
echo "How are you connecting to your network"
echo "1. Wifi"
echo "2. Ethernet"
read netoption
case $netoption in
  1)
    echo "You selected Wifi"
    read -p "what is your SSID?" SSID
    read -p "what is your password?" password
    cp -f "src/secrets.h.template" "src/secrets.h"
    secrets="src/secrets.h"
    sed -i "s/^Rose/$SSID" "$secrets"
    sed -i "s/^12345678/$password" "$secrets"
    ;;
  2)
    echo "You selected Ethernet"
    ;;
  *)
    exit
    ;;
esac


currentip=$(ipconfig getifaddr en0) 
echo "We have to get a static IP address"
echo "Your current IP is:" $currentip
read -p "Please enter an IP address in the same subnet: " ipaddress
read -p "Please enter your subnet mask, typically 255.255.255.0: " subnetmask
read -p "Please enter your gateway address: " gateway




## lets do the magic!
# need to set up the netaddr.h with static IP
cp -f "src/netaddr.h.template" "src/netaddr.h"
netaddr="src/netaddr.h"
sed -i "s/^192.168.1.23/$ipaddress" "$netaddr"
sed -i "s/^192.168.1.1/$gateway" "$netaddr"
sed -i "s/^255.255.255.0/$subnetmask" "$netaddr"

if []
# now set up secrets.h IF we are using wifi




pio run -e lolin32_lite -t upload
