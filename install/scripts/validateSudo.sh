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
