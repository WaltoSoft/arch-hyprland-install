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
  "fastfetch"
  "kitty"
  "chromium"
  "nautilus"
  "wofi"
  "gnome-text-editor"
  "git"
)

#These packages are required for my hyprland configuration
HYPRLAND_AURS=(
  "hyprland-git"
  "sddm-git"
  "uwsm"
  "xdg-desktop-portal-hyprland-git"
  "xdg-desktop-portal-gtk-git"
  "swaync-git"
  "polkit-gnome-git"
  "sddm-eucalyptus-drop"
)

#These are additional pacman packages I want to install
MY_PACMAN_PACKAGES=(
  "vim"
  "less"
  "man-db"
)

#These are Aur packages I want to install
MY_AURS=(
  "visual-studio-code-bin"    
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
