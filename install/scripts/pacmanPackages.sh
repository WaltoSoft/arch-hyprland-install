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
  local packagesToInstall=()

  for package; do
    if $(isInstalledWithPacman $package) ; then
      echoText -c $COLOR_GREEN "pacman package '${package}' is already installed"
    else
      packagesToInstall+=("${package}")
    fi
  done;

  installThem() {
    echoText "The following packages will be intalled with pacman: ${!packagesToInstall[@]}"
    pacman -Sq --noconfirm "${packagesToInstall[@]}" >> $LOG_FILE 2> >(tee -a $LOG_FILE >&2)    
  }

  checkThem() {
    local hasErrors=false

    for package in "${packagesToInstall[@]}"; do
      if ! $(isInstalledWithPacman $package) ; then
        hasErrors=true
        echoText -c $COLOR_RED "Package ${package} was not installed with pacman"
      else
        echoText "Package '${package}' was successfully installed with pacman"
      fi
    done

    echo ! hasErrors;
  }

  if installThem ; then
    if checkThem ; then
      echoText -c $COLOR_GREEN "All packages were successfully installed with pacman"
    else
      exit 1
    fi
  else
    echoText -c $COLOR_RED "An error occurred while installing packages with pacman"
    exit 1
  fi
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
