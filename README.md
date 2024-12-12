# Billy Walton's Arch Linux with Hyprland installer

Welcome to the installation script that sets up my Arch Linux environment the way I want it using Hyprland as the window manager.

Please note, that this script is only meant to be used by the owner.  I am not responsible for any damage this script causes if you run this on your own machine.

This script is meant to be run on a machine that is being logged into by a sudo user immediately after a fresh installation of the minimal Arch Linux setup.

The following are installed and are referenced in my Hyprland implementation

1.  Hyprland (Tiling Compositor for Wayland) - AUR - hyprland-git
2.  SDDM (Login Manager With the Eucalyptus Drop theme) - AUR - sddm-git, sddm-eucalyptus-drop
2.  kitty (Terminal) - pacman - kitty
3.  Chromium (Web Browser) - pacman - chromium
4.  Nautilus (File Manager) - pacman - nautilus
5.  Gnome Text Editor - pacman - gnome-text-editor
6.  Visual Studio Code - AUR - visual-studio-code-bin
7.  swaync (Notification daemon) -swaync-git
8.  Gnome policy kit (Authentication GUI) - AUR - polkit-gnome-git
9.  Hyprland Desktop Portal (Hyprland's xdg-desktop-portal implementation) - AUR - xdg-desktop-portal-hyprland-git
10. GTK Desktop Portal (Fall back desktop portal needed because the Hyprland once does not implement a file picker) - AUR - xdg-desktop-portal-gtk-git
11. fastfetch (I have configured .bashrc to use this to display system information when launching a terminal) - pacman - fastfetch
12. wofi (used to display a graphical menu) - pacman - wofi
13. uwsm (used by system-d to launch Hyprland) - AUR - uwsm
14. git
    
The following additional tools are installed:
1.  vim (TTY text editor)
3.  less (used by git)
4.  man-db (used by man, which is used by git --help)
5.  rysnc (used by the setup script)
6.  gum (used by th install script to prompt the user)

Items for research
1. Do I need to configure nautilus for something called inode/directory - See https://github.com/prasanthrangan/hyprdots/blob/main/Scripts/install_pst.sh
2. 


