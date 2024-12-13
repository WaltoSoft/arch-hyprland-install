executeScript() {
  local sddmConfigFolder=/etc/sddm.conf.d
  local sddmConfigFile=$sddmConfigFolder/sddm.conf
  local defaultConfigFile=/usr/lib/sddm/sddm.conf.d/default.conf
  local iniUpdateScript=$SCRIPTS_DIR/iniupdate.py
  local themeDirectory=/usr/share/sddm/themes

  echoText -fc $COLOR_AQUA "sddm"
  ensureFolder $sddmConfigFolder 
  copyDefaultConfiguration
  configureThemes
  selectTheme
}

copyDefaultConfiguration() {
  echoText "Copying Default SDDM Configuration '${defaultConfigFile}'->'${sddmConfigFile}'"
  cp $defaultConfigFile $sddmConfigFile
  echoText "Default SDDM Configuration copied"
}

getInstalledThemes() {
  local themes=()

  for folder in $themeDirectory/*; do
    if [ -d $folder ]; then
      local themeName=$(basename $folder)
      themes+=("${themeName}")
    fi
  done

  echo "${themes[@]}";
}

selectTheme() {
  local themeOptions=($(getInstalledThemes))

  if [ "${#themeOptions[@]}" -eq 0 ] ; then
    echoText "There are no sddm themes installed"
  else
    local selectedTheme=$(askUser -m  "Please select a login theme" "${themeOptions[@]}")

    echoText "Selected Theme: ${selectedTheme}"
    python $iniUpdateScript $sddmConfigFile Theme Current $selectedTheme
  fi
}

configureThemes() {
  #These three themes are installed by SDDM but they don't
  #work on Hyprland for some reason
  rm -rf $themeDirectory/elarun
  rm -rf $themeDirectory/maldives
  rm -rf $themeDirectory/maya

  configureEucalyptusDrop
}

# Add functions to configure various theme choices
configureEucalyptusDrop() {
  local configFile=$themeDirectory/eucalyptus-drop/theme.conf

  if [ -f $configFile ]; then 
    python $iniUpdateScript $configFile General HourFormat '"h:mm AP"'
    python $iniUpdateScript $configFile General DateFormat '"dddd, MMMM d"'
  else
    echoText "Eucalyptus Drop theme not found"
  fi
}

executeScript