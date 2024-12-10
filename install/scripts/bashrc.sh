executeScript() {
  echoText -fc $COLOR_AQUA "bashrc"
  echoText "Copying bashrc configuration scripts"

  doit() {
    sudo -u $SUDO_USER cp $INSTALL_DIR/home/.bashrc /home/$SUDO_USER/.bashrc >> $LOG_FILE 2> >(tee -a $LOG_FILE >&2)
    sudo -u $SUDO_USER cp $INSTALL_DIR/home/.bashrc_custom /home/$SUDO_USER/.bashrc_custom >> $LOG_FILE 2> >(tee -a $LOG_FILE >&2)
  }

  if ! doit; then
    echoText -c $COLOR_RED "ERROR: An error occured copying bashrc scripts"
    exit 1
  fi

  echoText -c $COLOR_GREEN "bashrc scripts successfully copied"
}

executeScript