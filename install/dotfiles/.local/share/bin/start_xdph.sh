start_xdph
#!/usr/bin/env bash

#NOTE The sleep statements are ncessary to 
#make sure that the 2 portals are started in the 
#proper order, and also to make sure this happens
#after setting some environment variables.  See note
#in autostart.conf

sleep 1
killall -e xdg-desktop-portal-hyprland
killall xdg-desktop-portal
/usr/lib/xdg-desktop-portal-hyprland &
sleep 2
/usr/lib/xdg-desktop-portal &