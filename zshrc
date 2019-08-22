# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nosharehistory
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/matthew/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export GIT_PS1_SHOWDIRTYSTATE=1

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '
#PS1='\w$(__git_ps1 " (%s)"\$ '
#PS1='[\u@\h \W]$(__git_ps1 " (%s)")\$ '

PROMPT='[%n@%m %1~]%# '

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
#dbus-update-activation-environment --systemd --all
dbus-update-activation-environment --systemd

# Flutter path
export PATH=/home/matthew/Development/flutter/bin:$PATH

# Ignore jrnl entries
HISTIGNORE="jrnl *"

# VirtualEnvWrapper
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh
