executeScript() {
  set -e

  local scriptsDir=$(dirname "$(realpath "$0")")
  
  source $scriptsDir/library.sh
  source $scriptsDir/validateSudo.sh
  source $scriptsDir/start.sh
  source $scriptsDir/pacmanPackages.sh
  source $scriptsDir/aurPackages.sh
  source $scriptsDir/dotfiles.sh
  source $scriptsDir/bashrc.sh
  source $scriptsDir/sddm.sh
  source $scriptsDir/grub.sh
  source $scriptsDir/reboot.sh
}

executeScript
