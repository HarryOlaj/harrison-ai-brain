# Jimmy↔Harry Always-On Link (launchd)

This package makes the Jimmy link persistent and self-healing on macOS.

For Jimmy's Windows runtime specifics (scheduled tasks, SSH/tunnel behavior, and recovery signatures), see:
- `infra/jimmy-link/WINDOWS_JIMMY_RUNBOOK.md`

## Components
- `com.harry.jimmy-tunnel`: SSH tunnel service (always-on).
- `com.harry.jimmy-nodehost`: Jimmy node host service (always-on).
- `com.harry.jimmy-watchdog`: 2-minute watchdog that:
  - checks Gate B truth condition via `check_gate_b.sh`
  - restarts tunnel + nodehost when Gate B fails
  - sends Discord alert only after retry budget is exhausted

## Truth condition (Gate B)
Connected == lightweight node action succeeds.
Default check: `GATE_B_CHECK_URL` returns HTTP 200/204.

## Setup
1. Edit config:
   ```bash
   cp config/jimmy-link.env.example config/jimmy-link.env
   chmod 600 config/jimmy-link.env
   # fill SSH + node host + token values
   ```
2. Install services:
   ```bash
   ./scripts/jimmy-link/install_launchd.sh
   ```
3. Validate:
   ```bash
   launchctl print gui/$UID/com.harry.jimmy-tunnel | head
   launchctl print gui/$UID/com.harry.jimmy-nodehost | head
   ./scripts/jimmy-link/check_gate_b.sh ./config/jimmy-link.env
   ```

## Alert policy
Set `DISCORD_WEBHOOK_URL` in `config/jimmy-link.env`.
Watchdog alerts only when auto-restart fails repeatedly (`MAX_RESTART_ATTEMPTS`).

## Rollback
```bash
for label in com.harry.jimmy-tunnel com.harry.jimmy-nodehost com.harry.jimmy-watchdog; do
  launchctl bootout "gui/$UID/$label" || true
done
rm -f ~/Library/LaunchAgents/com.harry.jimmy-*.plist
```
