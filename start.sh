#!/bin/bash

echo "[Swap Optimizer] Starting the path-finder service..."


LOCK_DIR="running_pid"
LOCK_FILE="$LOCK_DIR/app.pid"
LOG_DIR="logs"
mkdir -p "$LOG_DIR" "$LOCK_DIR"
TS="$(date +'%Y%m%d_%H%M%S')"
LOG_FILE="$LOG_DIR/run_${TS}.log"
echo $LOG_FILE

if [[ -f "$LOCK_FILE" ]]; then
  oldpid="$(cat "$LOCK_FILE" || true)"
  if [[ -n "${oldpid:-}" ]] && ps -p "$oldpid" > /dev/null 2>&1; then
    echo "[ERROR] Already running (pid=$oldpid). Refuse to start." >> $LOG_FILE
    echo "Please stop the process if it is stale" $LOG_FILE
    exit 1
  fi
  rm -rf "$LOCK_FILE"
fi

echo $$ > "$LOCK_FILE"

# Ensure .env exists
if [ ! -f .env ]; then
    echo "[ERROR] Missing .env file. Please run setup.sh first."
    exit 1
fi

# Run orchestrator logic
echo "[Swap Optimizer] Starting orchestrator..."
set +e
npm run build && npm start &
APP_PID=$!
set -e

echo "[INFO] App PID: $APP_PID"

(
  sleep 300
  pkill -f "node src/app.js"
  echo "[SWAP OPTIMIZER] Simulated crash: app.js stopped after 5 minutes." >> logs/output.log
) &

wait
