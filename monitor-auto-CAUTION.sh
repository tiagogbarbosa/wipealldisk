#!/bin/bash

INTERVAL=1
OLD_LIST=$(lsblk -nr -o NAME | grep -E '^sd[a-z]+$' | sort)
while true; do
  NEW_LIST=$(lsblk -nr -o NAME | grep -E '^sd[a-z]+$' | sort)
  DIFF=$(comm -13 <(echo "$OLD_LIST") <(echo "$NEW_LIST"))
  if [ -n "$DIFF" ]; then
    for DEVICE in $DIFF; do
      sleep 3
      echo "New device detected: /dev/$DEVICE"
      ./wipealldisks.sh /dev/$DEVICE
    done
  fi
  OLD_LIST=$NEW_LIST
  sleep $INTERVAL
done
