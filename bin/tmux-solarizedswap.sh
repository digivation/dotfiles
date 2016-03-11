#!/bin/bash
# Swap light/dark themes

# Path to tmux light
tmux_light=~/.config/solarized/solarized/tmux/tmuxcolors-light.conf
tmux_dark=~/.config/solarized/solarized/tmux/tmuxcolors-dark.conf

# Get the link target for .tmux.conf
conf_target=`readlink ~/.tmux.conf | xargs basename`

# Function to perform the change
function change_tmuxconf () {
    rm ~/.tmux.conf;
    ln -s $1 ~/.tmux.conf 
    tmux source-file ~/.tmux.conf
}

# See if we have an argument
args=("$@")

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

#if [ $conf_target = `basename $tmux_dark` ]; then
#    echo "Found Dark theme, switching to Light..."
#    change_tmuxconf $tmux_light
#elif [ $conf_target = `basename $tmux_light` ]; then
#    echo "Found Light theme, switching to Dark..."
#    change_tmuxconf $tmux_dark
#else
#    echo "No theme found, exiting"
#fi

