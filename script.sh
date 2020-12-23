#!/bin/bash

networkstatus=$(curl google.com)

exitstatus=$?
if [ $exitstatus = 0 ]; then
  echo "YES"
else
  echo "network down"
  ssid=$(whiptail --title  "LAN is down. try raise WLAN" --inputbox  "SSID" 10 60 3>&1 1>&2 2>&3)
  password=$(whiptail --title  "WLAN" --inputbox  "PASSWORD" 10 60 3>&1 1>&2 2>&3)
  echo "show interface -->"
  sleep 1
  ip a
  sleep 3
  interface=$(whiptail --title  "wlan interface" --inputbox  "interface" 10 60 3>&1 1>&2 2>&3)

  rm /etc/wpa_supplicant.conf
  touch /etc/wpa_supplicant.conf

  echo "network={" >> /etc/wpa_supplicant.conf
  echo "  ssid=\"$ssid\"" >> /etc/wpa_supplicant.conf
  echo "  psk=\"$password\"" >> /etc/wpa_supplicant.conf
  echo "}" >> /etc/wpa_supplicant.conf

  wpa_supplicant -Dln80211 -i $interface -c /etc/wpa_supplicant.conf
  dhcpcd $interface

  networkstatus=$(curl google.com)

  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    echo "network up --->"
    sleep 2
  else
    echo "ERR: network not working"
    exit 1
  fi
fi

partition=$(whiptail --title  "disk" --inputbox  "Path to disk. example: /dev/sdX1" 10 60 /dev/sd 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ];  then
  echo "1"
fi

OPTION=$(whiptail --title  "Menu Dialog" --menu  "GPT OR MBR" 15 60 4 \
"2" "GPT" \
"1" "MBR" \
  3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ];  then
     echo "Your chosen option:" $OPTION "and disk" $partition
fi
