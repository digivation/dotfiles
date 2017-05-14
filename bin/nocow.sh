#!/bin/bash

if [ $# != 2 ]
then
    echo "Usage: $0 inputfile tempfile "
    exit 0
fi

FILE=$1
TMP=$2

if ! [ -e "$FILE" ]
then
    echo "$FILE doesn't exist"
    exit 0
fi

if [ -e "$TMP" ]
then
    echo "$TMP exists! Please use a non-existent temp name"
    exit 0
fi

if [ -d "$FILE" ]
then
    echo "directories are not supported yet."
    exit 0
fi

echo "Converting $FILE(via $TMP).."

touch "$TMP"
chattr +C "$TMP"
dd if="$FILE" of="$TMP" bs=1M
rm "$FILE"
mv "$TMP" "$FILE"

exit 0
