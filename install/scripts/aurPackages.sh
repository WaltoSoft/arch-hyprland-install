executeScript() {
  local aurPackages=( ${HYPRLAND_AURS[*]} ${MY_AURS[*]} )

  echoText -fc $COLOR_AQUA "Aur Packages"
  installYay
  installPackagesWithYay "${aurPackages[@]}"
}

installPackagesWithYay() {
  for package; do
    if $(isInstalledWithPacman $package); then
      echoText -c $COLOR_GREEN "yay package '${package}' is already installed"
    else
      echoText "Installing yay package '${package}'"

      doit() {
        sudo -u $SUDO_USER yay -Sq --noconfirm $package >> $LOG_FILE 2>&1
      }

      if ! doit ; then
        echoText -c $COLOR_RED "ERROR: Error occurred executing yay on package '${package}'"
        exit 1
      else
        if $(isInstalledWithPacman $package); then
          echoText -c $COLOR_GREEN "yay package '${package}' installed successfully"
        else
          echoText -c $COLOR_RED "ERROR: yay package '${package}' was not installed"
          exit 1
        fi
      fi      
    fi
  done
}

installYay() {
  local yayGitFolder="${GIT_DIR}/yay-git"

  if ! $(isInstalledWithPacman 'yay-git') ; then
    echoText "yay is not installed.  Building and installing yay from code"
    removeExistingFolder $yayGitFolder
    cloneRepo 'https://aur.archlinux.org/yay-git' $yayGitFolder
    cd $yayGitFolder
   
    doit() {
      echoText "Compiling the 'yay-git' package"
      sudo -u $SUDO_USER makepkg -si --noconfirm >> $LOG_FILE 2>&1
    }

    if ! doit ; then
      echoText -c $COLOR_RED "ERROR: yay-git could not be compiled"
      exit 1
    fi

    if $(isInstalledWithPacman 'yay-git') ; then
      echoText -c $COLOR_GREEN "yay-git installed successfully"
    else
      echoText -c $COLOR_RED "ERROR: yay-git failed to install"
      exit 1
    fi
  else
    echoText -c $COLOR_GREEN "yay is already installed!"
  fi
}

executeScript