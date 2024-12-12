executeScript() {
  local grubScriptFile=/boot/grub/grub.cfg
  local grubConfigFile=/etc/default/grub
  local grubThemesFolder=/usr/share/grub/themes

  if isInstalledWithPacman grub && [ -f $grubScriptFile ] ; then
    if [ ! -f "${grubConfigFile}.ahi.bkp" ] && [ ! -f "${grubScriptFile}.ahi.bkp" ]; then
      echoText -fc $COLOR_AQUA "Grub"

      echoText "Configuring Grub"

      cp $grubConfigFile "${grubConfigFile}.ahi.bkp"
      cp $grubScriptFile "${grubScriptFile}.ahi.bkp"

      ensureFolder $grubThemesFolder/arch-linux

      echoText "Setting grub theme to arch-linux"
      tar -C $grubThemesFolder/arch-linux -xf $REPO_DIR/install/assets/arch-linux.tar
      
      sed -i "/^GRUB_DEFAULT=/c\GRUB_DEFAULT=saved
      /^GRUB_GFXMODE=/c\GRUB_GFXMODE=1920x1080
      /^GRUB_TERMINAL_OUTPUT=console/c\#GRUB_TERMINAL_OUTPUT=console
      /^GRUB_THEME=/c\GRUB_THEME=\"${grubThemesFolder}/arch_linux/theme.txt\"
      /^#GRUB_THEME=/c\GRUB_THEME=\"${grubThemesFolder}/arch_linux/theme.txt\"
      /^#GRUB_SAVEDEFAULT=true/c\GRUB_SAVEDEFAULT=true" $grubConfigFile

      echoText "Making the new grub script file"
      grub-mkconfig -o $grubScriptFile

      echoText -c $COLOR_GREEN "Grub ocnfiguration complete!"
    fi
  fi
}

executeScript
