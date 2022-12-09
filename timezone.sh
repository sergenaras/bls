#!/bin/bash

TR="
## TURKIYE TIMEZONE\n
server 0.tr.pool.ntp.org\n
server 1.tr.pool.ntp.org\n
server 2.tr.pool.ntp.org\n
server 3.tr.pool.ntp.org\n
"

chrony_config(){
  timedatectl set-timezone Europe/Istanbul
	
  sed -i 's/^\(.*ntp\.ubuntu\.com\)/#\1/g' /etc/chrony/chrony.conf
  sed -i 's/^\(.*pool\.ntp\.org\)/#\1/g' /etc/chrony/chrony.conf
  echo -e $TR >> /etc/chrony/chrony.conf

  systemctl restart chrony > /dev/null 2>&1
}

## Main code

dpkg -l | grep chrony >> /dev/null 2>&1

if [ $(echo $?) -eq "0" ]
then
  chrony_config
elif [ $(echo $?) -eq "1" ]
then
  apt -y install chrony > /dev/null 2>&1
  chrony_config
  systemctl --now enable chrony > /dev/null  2>&1
fi

timedatectl
