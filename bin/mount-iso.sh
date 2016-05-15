#!/bin/bash
MOUNT_BASE=/mnt/iso

# Get disk name
ISO_NAME=`isoinfo -d -i $1 | awk 'FNR == 3 {print $3}'`
echo "DISK: $ISO_NAME"
echo "FILE: $1"

# Check for mounted
if `mount | grep -qs "$1"`; then
    MOUNT_PATH=`mount | grep /home/matthew/xpl10_nodvd.iso | awk '{print $3}'`
    echo "$1 is mounted, unmounting..."
    umount $1

    echo "...removing directory $MOUNT_PATH"
    rmdir $MOUNT_PATH
else
    # Get image title (for path)
    ISO_NAME=`isoinfo -d -i $1 | awk 'FNR == 3 {print $3}'`

    echo "$1 is not mounted, mounting $1..."
    echo "...creating directory $MOUNT_BASE/$ISO_NAME"
    mkdir $MOUNT_BASE/$ISO_NAME
    mount -o loop $1 $MOUNT_BASE/$ISO_NAME
fi
