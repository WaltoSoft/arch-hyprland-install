executeScript() {
  echoText -fc $COLOR_AQUA "Dot files"
  echoText "Copying Hyperland Dot files"

  doit() {
    sudo -u $SUDO_USER rsync -avhp -I $INSTALL_DIR/dotfiles/ /home/$SUDO_USER >> $LOG_FILE 2> >(tee -a $LOG_FILE >&2)
  }

  if ! doit; then
    echoText -c $COLOR_RED "ERROR: An error occured copying Hyprland Dot files"
    exit 1
  fi

  echoText -c $COLOR_GREEN "Hyprland Dot files successfully copied"
}

executeScript;
