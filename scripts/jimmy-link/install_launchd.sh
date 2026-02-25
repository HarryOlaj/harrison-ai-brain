#!/usr/bin/env bash
set -euo pipefail

ROOT="/Users/aiharry/.openclaw/workspace"
LAUNCH_SRC="$ROOT/infra/jimmy-link/launchd"
AGENT_DST="$HOME/Library/LaunchAgents"

mkdir -p "$AGENT_DST" "$HOME/.jimmy-link/logs" "$HOME/.jimmy-link/state"

if [[ ! -f "$ROOT/config/jimmy-link.env" ]]; then
  cp "$ROOT/config/jimmy-link.env.example" "$ROOT/config/jimmy-link.env"
  chmod 600 "$ROOT/config/jimmy-link.env"
  echo "Created $ROOT/config/jimmy-link.env (edit before enabling services)."
fi

cp "$LAUNCH_SRC"/*.plist "$AGENT_DST"/
chmod 644 "$AGENT_DST"/com.harry.jimmy-*.plist
chmod +x "$ROOT"/scripts/jimmy-link/*.sh

for label in com.harry.jimmy-tunnel com.harry.jimmy-nodehost com.harry.jimmy-watchdog; do
  launchctl bootout "gui/$UID/$label" >/dev/null 2>&1 || true
  launchctl bootstrap "gui/$UID" "$AGENT_DST/$label.plist"
  launchctl kickstart -k "gui/$UID/$label"
  echo "Loaded $label"
done

echo "Install complete. Validate with:"
echo "  launchctl print gui/$UID/com.harry.jimmy-tunnel | head"
echo "  launchctl print gui/$UID/com.harry.jimmy-nodehost | head"
echo "  $ROOT/scripts/jimmy-link/check_gate_b.sh $ROOT/config/jimmy-link.env"
