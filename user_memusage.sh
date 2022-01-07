#!/bin/bash
stats=""
echo "%mem   user"
echo "============"

for user in `ps aux | grep -v COMMAND | awk '{print $1}' | sort -u`
do
  stats="$stats\n`ps aux | egrep ^$user | awk 'BEGIN{total=0}; \
    {total += $4};END{print total,$1}'`"
done

echo -e $stats | grep -v ^$ | sort -rn | head
