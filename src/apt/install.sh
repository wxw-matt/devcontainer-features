#!/usr/bin/env bash
set -e
LOG_DIR="/var/log/devcontainer-feature-apt"
DEBUG_FILE="$LOG_DIR/.debug"

mkdir -p $LOG_DIR
touch $DEBUG_FILE

debug_logln() {
  printf "$(date +"%Y-%m-%d %H:%M:%S"):\t$@\n" >> $DEBUG_FILE
}

apt-get update  && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends "$PACKAGES" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

