executeScript() {
  local pacmanPackages=( ${HYPRLAND_PACMAN_PACKAGES[*]} ${MY_PACMAN_PACKAGES[*]} )

  echoText -fc $COLOR_AQUA "Pacman Packages"
  pacman -Sy >> $LOG_FILE 2> >(tee -a $LOG_FILE >&2)
  echoText "Updated pacman databases"
  installPackagesWithPacman "${pacmanPackages[@]}"
}

installPackagesWithPacman() {
  for package; do
    if $(isInstalledWithPacman $package) ; then
      echoText -c $COLOR_GREEN "pacman package '${package}' is already installed"
    else
      echoText "Installing pacman package '${package}'"

      doit() {
        pacman -Sq --noconfirm $package >> $LOG_FILE 2> >(tee -a $LOG_FILE >&2)    
      }

      if ! doit ; then
        echoText -c $COLOR_RED "ERROR: Error occurred installing pacman package '${package}"
        exit 1
      else
        if $(isInstalledWithPacman $package) ; then
          echoText -c $COLOR_GREEN "pacman package '${package}' installed successfully"
        else
          echoText -c $COLOR_RED "ERROR: pacman package '${package}' was not installed"
          exit 1
        fi
      fi
    fi
  done;
}

isInstalledWithPacman() {
  local package="$1"
  local isInstalled="$(pacman -Qq "${package}" 2>> $LOG_FILE)"

  if [ -n "${isInstalled}" ] ; then
    echo true
  else
    echo false
  fi
}

executeScript