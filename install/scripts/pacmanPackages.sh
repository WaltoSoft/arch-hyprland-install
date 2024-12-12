executeScript() {
  local pacmanPackages=( ${HYPRLAND_PACMAN_PACKAGES[*]} ${MY_PACMAN_PACKAGES[*]} )

  echoText -fc $COLOR_AQUA "Pacman Packages"
  configurePacman
  installPackagesWithPacman "${pacmanPackages[@]}"
}

configurePacman() {
  if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.ahi.bkp ]; then
    echoText "Configuring pacman"

    doit() {  
      cp /etc/pacman.conf /etc/pacman.conf.ahi.bkp
      sed -i "/^#Color/c\Color\nILoveCandy
      /^#VerbosePkgLists/c\VerbosePkgLists
      /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
      
      sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

      pacman -Syyu >> $LOG_FILE 2> >(tee -a $LOG_FILE >&2)
      pacman -Fy >> $LOG_FILE 2> >(tee -a $LOG_FILE >&2)

      echoText -c $COLOR_GREEN "pacman configured"
    }

    if doit ; then
      echoText -c $COLOR_GREEN "pacman successfully configured"
    else
      echoText -c $COLOR_RED "ERROR: An error occurred configuring pacman"
    fi
  else
    echoText -c $COLOR_GREEN "pacman already configured"
  fi
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
