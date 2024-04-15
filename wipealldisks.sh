#!/bin/bash

# Running this script as root on your system will destroy or render inacessible all data on all disks.
# Proceed at your own risk.

if [[ ! "`whoami`" = "root" || -z "$1" ]]
then
    echo "This script must be run as root. Exiting..."
    exit 1
fi

DISK="$1"

echo "WARNING: This will permanently erase or render inaccessible all data on all disks! This includes: `for i in DISK ; do echo "/dev/$DISK" ; done`."
echo "Are you sure you wish to continue? Yes/No "

read input
if ! [[ `echo $input |egrep -i '^y$|^yes$'` ]]; then
    echo "Action cancelled. Exiting..."
    exit
fi

    echo "Wiping: $DISK..."
    wipefs -a $DISK
    parted -s $DISK mklabel gpt
    dd if=/dev/zero of=$DISK bs=512 count=100000 &> /dev/null
    blkcount=`blockdev --getsz $DISK`
    end=`expr $blkcount - 100000`
    dd if=/dev/zero of=$DISK bs=512 seek=$end count=100000 &> /dev/null
    echo "WipeAllDisk successfully erased: $DISK."

