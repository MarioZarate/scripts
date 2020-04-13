#!/bin/bash

#https://rclone.org/install/
#https://rclone.org/dropbox/
#https://rclone.org/flags/

#/usr/bin/flock -n /tmp/rclone_sync.lock /usr/local/src/rclone_sync.sh


LOCAL_FOLDER="/root"
REMOTE_FOLDER="Databases/"
INCLUDE_FILE="/usr/local/src/rclone_databases-include-file.txt"
LOG_FILE="/usr/local/src/rclone_databases.log"

#run sync
rclone sync $LOCAL_FOLDER remote:$REMOTE_FOLDER --include-from $INCLUDE_FILE --log-file $LOG_FILE --log-level INFO
