source $SCRIPTS_DIR/serviceList.sh

executeScript() {
  echoText -fc $COLOR_AQUA "Services"
  echoText "Enabling Services"

  for service in "${SERVICE_LIST[@]}"; do
    if enableService ; then
      echoText "Service '${service}' has been enabled"
    else
      echoText -c $COLOR_RED "ERROR: Error occurred enabling '${service}' service"
      exit 1
    fi
  done

  echoText -c $COLOR_GREEN "All services enabled successfully"
}

enableService() {
    existsOrExit $1, "enableService was called with no service name"
    service=$1
    systemctl enable "${service}.service" >> $LOG_FILE 2> >(tee -a $LOG_FILE >&2)
}

executeScript