#!/bin/sh
# Continuously writes timestamped log lines to a shared volume,
# occasionally emitting an ERROR line so there's something to find
# and alert on later in the lab.
LOG_FILE=/var/log/app/app.log
mkdir -p "$(dirname "$LOG_FILE")"
touch "$LOG_FILE"

i=0
while true; do
  i=$((i + 1))
  ts=$(date -u +"%Y-%m-%dT%H:%M:%S")
  if [ $((i % 8)) -eq 0 ]; then
    echo "$ts ERROR Failed to process order $((RANDOM % 9000)): timeout" >> "$LOG_FILE"
  else
    echo "$ts INFO Processed request $i successfully" >> "$LOG_FILE"
  fi
  sleep 2
done
