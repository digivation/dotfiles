#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s checkwinsize

# Git helper
. /usr/share/git/completion/git-prompt.sh

# Tmux X11 Display Setter
. ~/.dotfiles/bin/update-x11-forwarding.sh

export GIT_PS1_SHOWDIRTYSTATE=1

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '
#PS1='\w$(__git_ps1 " (%s)"\$ '
PS1='[\u@\h \W]$(__git_ps1 " (%s)")\$ '

# Boot rbenv
#eval "$(rbenv init -)"
#PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"

# Fix for old GTK $ QT applications - https://wiki.archlinux.org/index.php/Font_Configuration
export GDK_USE_XFT=1
export QT_XFT=true

# Editor for yaourt PKGBUILD
export EDITOR=vim

# Set up Keychain
#eval $(keychain --eval --agents ssh -Q --quiet id_rsa)
if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

# Keychain Alias
alias ssh-unlock='eval $(keychain --eval --agents ssh -Q --quiet id_rsa)'

# Enable ssh-agent
#echo 'eval $(ssh-agent)'

# Evaluate dir_colors
if [ -f ~/.dir_colors ]; then
    eval `dircolors ~/.dir_colors`
else
    eval `dircolors`
fi

# Solarized swap
alias sswap='~/.dotfiles/bin/solarizedswap.sh'

# Export for Systemd User
dbus-update-activation-environment --systemd --all

# Flutter path
export PATH=/home/matthew/Development/flutter/bin:$PATH

# Ignore jrnl entries
HISTIGNORE="jrnl *"

# VirtualEnvWrapper
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh
