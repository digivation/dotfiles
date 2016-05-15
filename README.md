# dotfiles
My dotfiles my be crappy, but they are mine and I love them.

# bin/
Bin contains a variety of little scripts to do various tasks. It's a playground of sorts.

* mount-iso.sh - this script accepts the path to an ISO file. Mountpoint will be created and file mounted. If file is already mounted, it will be unmounted and the mount point will be removed. I have this as a custom Thunar action for ISO files.
* mail-launch.sh - Launches Google Inbox to handle mailto: links. I pilfered this from a google search...
* solarizedswap.sh - swaps between dark and light solarized themes. Currently changes tmux and vim. Supports swapping (if no argument, just switches to the other) or explicit 'light' and 'dark' args.
* tmux-solarizedswap.sh - initial playground for tmux theme swap. Integrated into solarizedswap.sh now
* vim-solarizedswap.sh - initial playground for vim theme swap. Integrated into solarizedswap.sh now

# Sources
Initial inspiration to version my dotfiles from [Anish Athalye](http://www.anishathalye.com/2014/08/03/managing-your-dotfiles/) (amongst other places).

# Various Notes
## Update dotbot
    git submodule update --remote dotbot
