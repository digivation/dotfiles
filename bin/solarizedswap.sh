#!/bin/bash
# Swap light/dark themes

# Path to tmux light
tmux_light=~/.config/solarized/solarized/tmux/tmuxcolors-light.conf
tmux_dark=~/.config/solarized/solarized/tmux/tmuxcolors-dark.conf

# Get the link target for .tmux.conf
conf_target=`readlink ~/.tmux.conf | xargs basename`

# Function to perform tmux change
function change_tmuxconf () {
    rm ~/.tmux.conf;
    ln -s $1 ~/.tmux.conf 
    tmux source-file ~/.tmux.conf
}

# Function to perform vim change
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


# Logic!
if [ "${args[0]}" = "light" ]; then
#    echo "Requesting light"
    change_tmuxconf $tmux_light
elif [ "${args[0]}" = "dark" ]; then
#    echo "Requesting dark"
    change_tmuxconf $tmux_dark
elif [ $conf_target = `basename $tmux_dark` ]; then
    change_tmuxconf $tmux_light
elif [ $conf_target = `basename $tmux_light` ]; then
    change_tmuxconf $tmux_dark
fi


