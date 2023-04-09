#!/usr/bin/env bash
set -e
LOG_DIR="/var/log/command_runner"
DEBUG_FILE="$LOG_DIR/.debug"

mkdir -p $LOG_DIR
touch $DEBUG_FILE

debug_logln() {
  printf "$(date +"%Y-%m-%d %H:%M:%S"):\t$@\n" >> $DEBUG_FILE
}

run_as() {
    local username=$1
    shift
    COMMAND="$@"
    if [ "$(id -u)" -eq 0 ] && [ "$username" != "root" ]; then
        su - "$username" -c "$COMMAND"
    elif [[ $COMMAND == "su -"* ]]; then
        debug_logln "su - $COMMAND"
        $COMMAND
    else
        bash -c "$COMMAND"
    fi
}

get_current_user() {
    local username="${_REMOTE_USER:-"automatic"}"
    # Determine the appropriate non-root user
    if [ "${username}" = "auto" ] || [ "${username}" = "automatic" ]; then
        username=""
        possible_users=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
        for current_user in "${possible_users[@]}"; do
            if id -u "${current_user}" > /dev/null 2>&1; then
                username="${current_user}"
                break
            fi
        done
        if [ "${username}" = "" ]; then
            username=root
        fi
    elif [ "${username}" = "none" ] || ! id -u ${username} > /dev/null 2>&1; then
        username=root
    fi
    echo "$username"
}

debug_logln "Current user: $(get_current_user)"

# Loop through the commands
for i in {1..10}
do
  command="COMMAND$i"
  the_command="${!command}"

  # Check if the command is empty
  if [ -z "${the_command}" ]
  then
    # If the commandiable is empty, skip to the next one
    debug_logln "Skipping empty command: $command"
    continue
  fi

  # If the command is not empty, do something with it
  current_user=$(get_current_user)
  debug_logln "Processing $the_command as ${current_user}"
  run_as $current_user $the_command
done
