#!/bin/bash

clear
echo "Welcome to the installer, lets get started!\n"

echo "We require Hombrew to compile the firmware, do you want to install HomeBrew?"
read -p "Yes, No, Skip if you already have installed (y/N/s): " agree

case $agree in
  y)
    ## installing Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ;;
  s)
    continue
    ;;
  *)
    exit
    ;;
esac



## installing git and platformio
brew install git

if [ -d "GNATS/" ]; then
  read -p "Directory exists, do you want to delete? (y/N): " delete
  if [$delete -eq 'y']; then
    rm -rf GNATS/
  fi
fi


## Cloning GNATS
git clone https://github.com/jeff-comley/GNATS.git && cd GNATS



# are we using Wifi or Ethernet?
echo "\nHow are you connecting to your network"
echo "1. Wifi"
echo "2. Ethernet"
read $netoption
case $netoption in
  1)
    echo "You selected Wifi"
    read -p "what is your SSID?" SSID
    read -p "what is your password?" password
    cp "src/secrets.h.template" "src/secrets.h"
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
cp "src/netaddr.h.template" "src/netaddr.h"
netaddr="src/netaddr.h"
sed -i "s/^192.168.1.23/$ipaddress" "$netaddr"
sed -i "s/^192.168.1.1/$gateway" "$netaddr"
sed -i "s/^255.255.255.0/$subnetmask" "$netaddr"

if []
# now set up secrets.h IF we are using wifi




pio run -e lolin32_lite -t upload