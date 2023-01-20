#!/bin/bash

set -euo pipefail

AUDIT_RULES="
## Docker Audit Rules\n
-w /usr/bin/docker -p rwxa -k docker\n
-w /usr/bin/dockerd -p rwxa -k dockerd\n
-w /usr/bin/docker-compose -p rwxa -k docker-compose\n
"

FILE="/etc/audit/rules.d/docker.rules"

backup(){
	BFILE=/$HOME/acb-$(date +"%FT%T") # acb = audit custom backup
	if [ -f "$FILE" ]; then
		mkdir $BFILE
	else 
		continue
	fi

	mv $FILE $BFILE
	echo "Backup dosyaları alındı."
}

create(){
	touch $FILE
}

audit(){
	echo -e $AUDIT_RULES > $FILE
	service auditd stop 
	service auditd start
}

if [ -f "$FILE" ]; then
	backup
	audit
else 
    create
	audit
fi
