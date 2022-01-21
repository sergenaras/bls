#!/bin/bash

authconfig --passminlen=14 --passminclass=3 --passmaxrepeat=2 --passmaxclassrepeat=2 --enablerequpper --enablereqother --enablereqdigit --update
echo "password    requisite     pam_pwhistory.so remember=24 use_authtok" >> /etc/pam.d/password-auth
sed -i 's/PASS_MAX_DAYS.*/PASS_MAX_DAYS 42/' /etc/login.defs
sed -i 's/PASS_MIN_DAYS.*/PASS_MIN_DAYS 1/' /etc/login.defs
sed -i 's/PASS_MIN_LEN.*/PASS_MIN_LEN 14/' /etc/login.defs
