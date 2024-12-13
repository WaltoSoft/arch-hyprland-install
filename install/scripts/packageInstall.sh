source $SCRIPTS_DIR/packageList.sh

executeScript() {
  local yayUrl='https://aur.archlinux.org/yay-git'
  local yayGitFolder="${GIT_DIR}/yay-git"

  configurePacman
  installYay
  installPackages
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

installPackages() {
  local packagesToInstall=()
  local aursToInstall=()

  for package in "${PACKAGE_LIST[@]}"; do
    if $( isPackageInstalled $package ) ; then
      echoText "Package '${package}' is already installed"
    elif $( isPackageAvailable $package ) ; then
      echoText "Queuing package '${package}' to be installed with pacman"
      packagesToInstall+=("${package}")
    elif $( isAurAvailable $package ) ; then
      echoText "Queuing package '${package}' to be installed with yay"
      aursToInstall+=("${package}")
    else
      echoText -c $COLOR_RED "Unknown package '${package}'"
      exit 1
    fi
  done

  installPacmanPackages() {
    if [[ ${#packagesToInstall[@]} -gt 0 ]] ; then
      echoText "Installing pacman pacakges"
      pacman -Sq --noconfirm "${packagesToInstall[@]}" >> $LOG_FILE 2> >(tee -a $LOG_FILE >&2)
    else
      echoText "No pacman packages to install"
    fi
  }

  installYayPackages() {
    if [[ ${#aursToInstall[@]} -gt 0 ]] ; then
      echoText "Installing aur packages"
      sudo -u $SUDO_USER yay -Sq --noconfirm "${aursToInstall[@]}" >> $LOG_FILE 2>&1  }
    else
      echoText "No aur packages to install"
    fi
  }

  local hasErrors=false

  if ! installPacmanPackages ; then
    echoText -c $COLOR_RED "ERROR: An error occurred installing pacman packages"
    exit 1
  fi

  if ! installYayPackages ; then 
    echoText -c $COLOR_RED "ERROR: An error occurred installing yay packages"
    exit 1
  fi

  for package in "${PACKAGE_LIST[@]}"; do
    if $( isPackageInstalled $package ) ; then
      echoText "Package '${package}' installed successfully"
    else
      echoText "Package '${package}' was not installed"
      exit 1
    fi
  done

  echoText -c $COLOR_GREEN "All packages successfully installed"
}

installYay() {
  if ! $(isPackageInstalled 'yay-git') ; then
    echoText "yay is not installed.  Building and installing yay from code"
    removeExistingFolder $yayGitFolder
    cloneRepo $yayUrl $yayGitFolder
    cd $yayGitFolder
   
    doit() {
      echoText "Compiling the 'yay-git' package"
      sudo -u $SUDO_USER makepkg -si --noconfirm >> $LOG_FILE 2>&1
    }

    if ! doit ; then
      echoText -c $COLOR_RED "ERROR: yay-git could not be compiled"
      exit 1
    fi

    if $(isPackageInstalled 'yay-git') ; then
      echoText -c $COLOR_GREEN "yay-git installed successfully"
      rm -rf $yayGitFolder
    else
      echoText -c $COLOR_RED "ERROR: yay-git failed to install"
      exit 1
    fi
  else
    echoText -c $COLOR_GREEN "yay is already installed!"
  fi
}

isPackageInstalled() {
  existsOrExit $1 "isPackageInstalled was called with no package name"  

  local package="$1"
  local isInstalled="$(pacman -Qi "${package}" 2>> $LOG_FILE)"

  if [ -n "${isInstalled}" ] ; then
    echo true
  else
    echo false
  fi
}

isPackageAvailable() {
  existsOrExit $1 "isPackageAvailable was called with no package name"

  local package="$1"

  if pacman -Si $package &> /dev/null; then
    echo true
  else
    echo false
  fi
}

isAurAvailable() {
  existsOrExit $1 "isAurAvailable was called with no package name"

  local package="$1"

  if yay -Si $package &> /dev/null; then
    echo true
  else
    echo false
  fi
}

executeScript