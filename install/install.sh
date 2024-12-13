REPO_NAME=arch-hyprland-install
GIT_DIR=/home/$SUDO_USER/Git
REPO_DIR=$GIT_DIR/$REPO_NAME
INSTALL_DIR=$REPO_DIR/install
SCRIPTS_DIR=$INSTALL_DIR/scripts
LOGS_DIR=/var/log/$REPO_NAME
LOG_FILE="${LOGS_DIR}/$(date '+%Y%m%d%H%M%S').log"

#These are pacman packages that are used in my 
#Hyprland configuration
HYPRLAND_PACMAN_PACKAGES=(
  "blueman"
  "bluez"
  "bluez-utils"
  "brightnessctl"
  "cliphist"
  "chromium"
  "fastfetch"
  "git"
  "gnome-text-editor"
  "gst-plugin-pipewire"
  "kitty"
  "nautilus"
  "network-manager-applet"
  "networkmanager"
  "pacman-contrib"
  "parallel"
  "pamixer"
  "pavucontrol"
  "pipewire"
  "pipewire-alsa"
  "pipewire-audio"
  "pipewire-jack"                                          # pipewire jack client"
  "pipewire-pulse"
  "qt5-quickcontrols"
  "qt5-quickcontrols2"
  "qt5-graphicaleffects"
  "polkit-gnome"
  "rofi-wayland"
  "slurp"
  "swaync"
  "swappy"
  "udiskie"
  "waybar"
  "wireplumber"
  "wlogout"
)

#These packages are required for my hyprland configuration
HYPRLAND_AURS=(
  "hyprland-git"
  "hyprpicker-git"
  "sddm-git"
  "uwsm"
  "xdg-desktop-portal-hyprland-git"
  "xdg-desktop-portal-gtk-git"
  "sddm-eucalyptus-drop"
  "visual-studio-code-bin"
)

#These are additional pacman packages I want to install
MY_PACMAN_PACKAGES=(
  "cava"
  "less"
  "man-db"
  "spicetify-cli"
  "spotify"
  "vim"
)

#These are Aur packages I want to install
MY_AURS=(
)

COLOR_AQUA=14
COLOR_GREEN=10
COLOR_RED=9

executeScript() {
  set -e

  if [ "$EUID" -ne 0 ]; then
    echo "Please use sudo when running this script"
    exit 1
  fi

  source "${SCRIPTS_DIR}/library.sh"
  mkdir -p $LOGS_DIR

  doit() {
    local NO_PASSWORD_LINE="%wheel ALL=(ALL:ALL) NOPASSWD: ALL"
    local SUDOERS_FILE="/etc/sudoers"

    grep -qxF "${NO_PASSWORD_LINE}" "$SUDOERS_FILE" || echo "${NO_PASSWORD_LINE}" >> "$SUDOERS_FILE"
  }

  if ! doit ; then
    echoText -c $COLOR_RED "ERROR: An error occurred granting the wheel group NOPASSWORD sudo access"
    exit 1
  fi

  source "${SCRIPTS_DIR}/main.sh"
}

executeScript
