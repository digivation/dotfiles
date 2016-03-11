#!/bin/bash
# Swap light/dark themes

# Function to perform the change
function change_vimconf () {
    sed -i "s/background=.*/background=$1/g" ~/.vimrc
}

# See if we have an argument
args=("$@")

# Logic!
if [ "${args[0]}" = "light" ]; then
#    echo "Requesting light"
    change_vimconf 'light'
elif [ "${args[0]}" = "dark" ]; then
#    echo "Requesting dark"
    change_vimconf 'dark'
elif [ ! -z "`egrep 'background=dark' ~/.vimrc`" ]; then
#    echo "Found Dark!"
    change_vimconf "light"
elif [ ! -z "`egrep 'background=light' ~/.vimrc`" ]; then
#    echo "Found Light!"
    change_vimconf "dark"
fi

