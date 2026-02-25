# Jimmy↔Harry Link Runbook (Windows)

Date locked: 2026-02-25

## Final topology
- Harry gateway (Mac): `127.0.0.1:18789`
- Jimmy secure tunnel local forward: `127.0.0.1:18790 -> 192.168.50.169:22 -> 127.0.0.1:18789`
- Jimmy node host target: `--host 127.0.0.1 --port 18790`

## Why this topology
OpenClaw blocks remote plaintext node->gateway links to LAN IP (`ws://192.168.x.x`) for security. Tunnel+localhost is required.

## Key auth requirement
Use Git SSH with this option for Jimmy key auth:
- `-o PubkeyAuthentication=unbound`

Without that flag, debug logs may show `Server accepts key` but auth still fails.

## Scheduled tasks expected on Jimmy
- `\OpenClaw Gateway`
- `\OpenClaw Node`
- `\OpenClawLinkWatchdog`
- `\OpenClawTunnel`

## Scripts expected on Jimmy
- `C:\Users\Jimmy\.openclaw\scripts\jimmy_tunnel_run.cmd`
- `C:\Users\Jimmy\.openclaw\scripts\jimmy_tunnel_start.cmd`
- `C:\Users\Jimmy\.openclaw\scripts\jimmy_link_watchdog.cmd`

## Script behavior
### jimmy_tunnel_run.cmd
Runs tunnel in background-safe mode via Git SSH:
- key: `C:\Users\Jimmy\.ssh\id_ed25519_jimmy_harry`
- forward: `-L 18790:127.0.0.1:18789`
- user/host: `aiharry@192.168.50.169`
- logs: `C:\Users\Jimmy\.openclaw\logs\jimmy_tunnel.log`

### jimmy_tunnel_start.cmd
- Creates log dir if missing
- If local port 18790 already listening, exits
- Otherwise starts `jimmy_tunnel_run.cmd`

### jimmy_link_watchdog.cmd
- Ensures tunnel starter runs
- Restarts node if stopped
- Restarts gateway if probe not ok
- logs recovery actions to `C:\Users\Jimmy\.openclaw\logs\jimmy_watchdog.log`

## PowerShell policy note
If `openclaw.ps1` is blocked by execution policy, use `openclaw.cmd`.

## Validation commands
On Jimmy:
```powershell
openclaw.cmd node status
schtasks /Query /TN OpenClawTunnel /FO LIST
schtasks /Query /TN OpenClawLinkWatchdog /FO LIST
```

On Harry:
```bash
openclaw nodes status
```
Expect: `paired · connected`.

## Known failure signatures
1) `Permission denied (publickey,password,keyboard-interactive)`
- Usually missing/incorrect key auth flow or missing `PubkeyAuthentication=unbound` in Git SSH invocation.

2) `SECURITY ERROR: Cannot connect to "192.168.50.169" over plaintext ws://`
- Node configured to remote LAN ws directly; must use localhost tunnel target instead.

3) recurring console popups every ~2 min
- malformed watchdog script quoting or interactive task noise.
