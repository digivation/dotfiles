#!/bin/bash
MOUNT_BASE=/mnt/iso

# Get disk name
ISO_NAME=`isoinfo -d -i "$1" | awk 'FNR == 3 {print $3}'`
ISO_PATH=`realpath "$1"`
FNAME=${1##*/}

# Check for empty name and fix (if isoinfo cannot process)
if [ -z "$ISO_NAME" ]; then
    echo "Unable to get iso name, setting to filename"
    ISO_NAME=${FNAME%%.*}
fi

# The mount destination
MOUNT="$MOUNT_BASE"/"$ISO_NAME"

echo "DISK: $ISO_NAME"
echo "FILE: $1"
echo "FULL PATH: $ISO_PATH"
echo "MOUNTPOINT: $MOUNT"


# Check for mounted
#if `mount | grep -qs "$1"`; then
#if `mount | grep -qs "$MOUNT_BASE"/"$ISO_NAME"`; then
if `mount | grep -qs "$MOUNT"`; then
    MOUNT_PATH=`mount | grep "$ISO_PATH" | awk '{print $3}'`
    echo "$1 is mounted, unmounting..."
#    umount "$MOUNT_BASE"/"$ISO_NAME"
    umount "$MOUNT"

    echo "...removing directory $MOUNT"
    rmdir "$MOUNT"
else
    # Get image title (for path)
    #ISO_NAME=`isoinfo -d -i "$1" | awk 'FNR == 3 {print $3}'`

    echo "$1 is not mounted, mounting..."

    # see if the directory is laying around..
    if [ -d "$MOUNT" ]; then
	echo "...reusing $MOUNT"
    else
	echo "...creating directory $MOUNT"
	mkdir "$MOUNT"
    fi

    mount -o loop "$ISO_PATH" "$MOUNT"
#    fuseiso "$ISO_PATH" "$MOUNT_BASE/$ISO_NAME"
fi
