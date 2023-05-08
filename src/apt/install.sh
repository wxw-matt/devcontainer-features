#!/usr/bin/env bash
set -e
LOG_DIR="/var/log/devcontainer-feature-apt"
DEBUG_FILE="$LOG_DIR/.debug"

mkdir -p $LOG_DIR
touch $DEBUG_FILE

debug_logln() {
  printf "$(date +"%Y-%m-%d %H:%M:%S"):\t$@\n" >> $DEBUG_FILE
}

if [ -n "$LOCAL_MIRROR" ]; then
  # TODO check the geo position
  sed -i 's#http://archive.ubuntu.com#http://au.archive.ubuntu.com#g' /etc/apt/sources.list
  sed -i 's#http://ports.ubuntu.com#http://au.ports.ubuntu.com#g' /etc/apt/sources.list
fi

apt-get update  && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get install -y --no-install-recommends $PACKAGES

if [ -n "$CLEAN_CACHE" ]; then
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
fi