#!/bin/sh
# Launch Google Inbox

mail_base="https://inbox.google.com"

args=("$@")

if [ ! -z "${args[0]}" ]; then
    # Open a compose window to the address
    echo "Opening a compose window"
    # Strip 'mailto:' if it exists
    toaddr=`echo ${args[0]} | sed 's/mailto://'`
    echo $toaddr
    xdg-open $mail_base?to=$toaddr
else
    # Opening the inbox
    xdg-open $mail_base
fi
