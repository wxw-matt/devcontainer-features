#!/usr/bin/env bash
set -e
# CACHE_DIR="/scripts_runner/scripts"
CACHE_DIR="/usr/local/scripts_runner/scripts"
DEBUG_FILE="$CACHE_DIR/.debug"

mkdir -p $CACHE_DIR
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
    else
        $COMMAND
    fi
}

get_current_user() {
    local username="${username:-"${_REMOTE_USER:-"automatic"}"}"
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

download_with_retry() {
  local url="$1"
  local filename="$2"
  local max_retries=3
  local retry_count=0

  while [ $retry_count -lt $max_retries ]
  do
    status_code=$(curl --write-out %{http_code} -SL --silent --output $filename "$url")
    if [ $status_code -eq 200 ]; then
      echo "Download successful!"
      return 0
    else
      echo "Download failed with status code $status_code. Retrying in 2 seconds..."
      sleep 2
      retry_count=$((retry_count+1))
    fi
  done

  return 1 # failure
}

load_remote_bash() {
    local username='root'
    local run_as_user=0

    if [ $# -lt 2 ] ||  [ $# -gt 3 ]; then
        echo "Usage: load_remote_bash <remote_url> <filename>"
        echo "Or"
        echo "Usage: load_remote_bash <username> <remote_url> <filename>"
        return 1
    fi

    if [ $# -eq 3 ]; then
        username=$1
        run_as_user=1
        shift
    fi

    local url="$1"
    local filename="$2"
    local cache_dir="$CACHE_DIR"
    local cache_file="$cache_dir/$filename"

    if [ ! -d "$cache_dir" ]; then
        mkdir -p "$cache_dir"
    fi

    if [ ! -f "$cache_file" ]; then
        download_with_retry $url  $cache_file
        size=$(stat -c %s "$cache_file")

        if [ $size -eq 0 ]; then
            echo "Error: the size of the fetched content is 0 ($url)."
        fi
    fi
    if [ $run_as_user -eq 1 ]; then
        run_as $username /bin/bash "$cache_file"
    else
        /bin/bash "$cache_file"
    fi
}

load_and_execute_func() {
    if [ $# -ne 2 ]; then
        echo "Usage: load_and_execute_func <function_name> <remote_url>"
        return 1
    fi

    local func="$1"
    local url="$2"

    load_remote_bash $url
    eval $func
}

# Define the list of environment variables
no_scripts=1

# Loop through the scriptiables
for i in {1..10}
do
  script="SCRIPT$i"
  script_info="${!script}"
  filename="${script_info%%#*}"
  url="${script_info#*#}"

  # Check if the scriptiable is empty
  if [ -z "${script_info}" ]
  then
    # If the scriptiable is empty, skip to the next one
    debug_logln "Skipping $script: ${script_info} not specified"
    continue
  fi
  no_scripts=0

  # If the scriptiable is not empty, do something with it
  current_user=$(get_current_user)
  debug_logln "Processing $script as ${current_user}: ${filename}#${url}"
  load_remote_bash ${current_user} ${url} ${filename}
done

if [ "$no_scripts" -eq 1 ]; then
  echo "no_scripts" > "$CACHE_DIR"/.scripts_status
else
  echo "has_scripts" > "$CACHE_DIR"/.scripts_status
fi
