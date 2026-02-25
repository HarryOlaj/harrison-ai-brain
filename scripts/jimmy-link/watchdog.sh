#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${1:-$HOME/.openclaw/workspace/config/jimmy-link.env}"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing env file: $ENV_FILE" >&2
  exit 2
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

mkdir -p "$STATE_DIR" "$LOG_DIR"
STATE_FILE="$STATE_DIR/restart_attempts"
: "${MAX_RESTART_ATTEMPTS:=3}"

log() {
  echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") $*" | tee -a "$LOG_DIR/watchdog.log"
}

send_alert() {
  local msg="$1"
  if [[ -n "${DISCORD_WEBHOOK_URL:-}" ]]; then
    curl -sS -X POST "$DISCORD_WEBHOOK_URL" \
      -H 'Content-Type: application/json' \
      -d "{\"content\":\"${ALERT_PREFIX} ${msg}\"}" >/dev/null || true
  fi
}

ensure_service() {
  local label="$1"
  if ! launchctl print "gui/$UID/$label" >/dev/null 2>&1; then
    log "service_missing label=$label -> bootout/bootstrap"
    launchctl bootout "gui/$UID/$label" >/dev/null 2>&1 || true
    launchctl bootstrap "gui/$UID" "$HOME/Library/LaunchAgents/$label.plist"
  fi
  launchctl kickstart -k "gui/$UID/$label" >/dev/null 2>&1 || true
}

attempts=0
if [[ -f "$STATE_FILE" ]]; then
  attempts=$(cat "$STATE_FILE" 2>/dev/null || echo 0)
fi

if "$HOME/.openclaw/workspace/scripts/jimmy-link/check_gate_b.sh" "$ENV_FILE" >/dev/null 2>&1; then
  echo 0 > "$STATE_FILE"
  log "gate_b_ok"
  exit 0
fi

log "gate_b_fail attempts=$attempts"
ensure_service "com.harry.jimmy-tunnel"
ensure_service "com.harry.jimmy-nodehost"

if "$HOME/.openclaw/workspace/scripts/jimmy-link/check_gate_b.sh" "$ENV_FILE" >/dev/null 2>&1; then
  echo 0 > "$STATE_FILE"
  log "recovered"
  exit 0
fi

attempts=$((attempts + 1))
echo "$attempts" > "$STATE_FILE"

if (( attempts >= MAX_RESTART_ATTEMPTS )); then
  log "unrecoverable after=${attempts}"
  send_alert "Unrecoverable link failure after ${attempts} attempts. Manual intervention required."
fi

exit 1
