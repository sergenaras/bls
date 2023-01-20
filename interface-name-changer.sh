#!/usr/bin/env bash

set -Eeuo pipefail

D1=$1
D2=$2

FILE1=/etc/sysconfig/network-scripts/ifcfg-$1
FILE2=/etc/sysconfig/network-scripts/ifcfg-$2

TD=$#

say(){
	if [[ $TD -lt 3 ]]; then 
		echo "$D1 arayüzü $D2 olacak şekilde değiştirilecektir."
	else
		echo "Çok fazla ağ arayüzü var. Sadece iki ağ arayüzü olabilir."
		exit 0
	fi
}

grub_rebuild(){
	sed -i 's/quiet.*/quiet net.ifnames=0 biosdevname=0"/' /etc/default/grub
	grub2-mkconfig -o /boot/grub2/grub.cfg >> /dev/null 2>&1
	echo "Grub yeniden yapılandırılmıştır"
}

change_name(){
	if [[ -f "$FILE1" ]]; then
		sed -i -r "s|NAME.*|NAME=$D2|" /etc/sysconfig/network-scripts/ifcfg-$D1
		sed -i -r "s|DEVICE.*|DEVICE=$D2|" /etc/sysconfig/network-scripts/ifcfg-$D1
		mv /etc/sysconfig/network-scripts/ifcfg-$D1 /etc/sysconfig/network-scripts/ifcfg-$D2
		systemctl disable NetworkManager >> /dev/null 2>&1
		echo "Device ve dosya adı değiştirilmiştir"
	else
		echo "$FILE1 isminde bir dosya yoktur."
		exit 0
	fi
}

reboot_sys () { 
	echo 'Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot; 
}

say
grub_rebuild
change_name
reboot_sys
