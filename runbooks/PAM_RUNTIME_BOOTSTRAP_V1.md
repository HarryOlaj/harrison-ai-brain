# PAM Runtime Bootstrap v1 (Jimmy Host)

## Current State
- Contract: `contracts/PAM_OPERATING_CONTRACT_V1.md` (active)
- Foundation docs synced in `brain/PAM/*`
- Jimmy host runtime folder currently missing: `C:\ai_ops\pam_runtime`
- Discord thread-bound subagent sessions are disabled in current OpenClaw account config

## Goal
Bring up Pam as a standalone assistant runtime on Jimmy host (Discord-first), then run acceptance tests.

## Requirements
1. Python 3.11+ on Jimmy host
2. Dedicated Pam Discord bot token (DM-only behavior)
3. Google credentials for calendar/tasks scopes
4. 1Password item(s) for all secrets (no chat-pasted credentials)

## Bootstrap Steps
1) Create runtime structure on Jimmy:
- `C:\ai_ops\pam_runtime\`
- `C:\ai_ops\pam_runtime\logs\`
- `C:\ai_ops\pam_runtime\state\`

2) Copy baseline assistant policy files from repo:
- `brain/PAM/PROFILE.md`
- `brain/PAM/INTAKE_RULES.md`
- `brain/PAM/ROUTINES.md`

3) Build `.secrets.env` from 1Password references (not plaintext in repo):
- `DISCORD_BOT_TOKEN_PAM`
- Google auth variables / paths
- Optional Twilio vars (disabled for v1)

4) Start Pam adapter/service process (DM-only):
- enforce deny on guild channels
- enforce shorthand intake classifier
- enforce escalation format to Harry/Jimmy

5) Add scheduled task(s):
- Pam runtime autostart at logon
- watchdog check every 2 min

## Acceptance Tests
A) Task shorthand:
- Input: "get bananas"
- Expected: Task created in Harry Industries with metadata

B) Calendar shorthand:
- Input: "call with Bob at 2 tomorrow"
- Expected: Conflict-safe flow, proposed/created slot with metadata

C) Follow-through format:
- Output must include:
  - CAPTURED
  - ACTION
  - CONFIRMATION
  - FOLLOW-UP

## Known Blockers
- OpenClaw setting `channels.discord.threadBindings.spawnSubagentSessions=true` is currently disabled, so persistent Pam subagent session in Discord cannot be launched from this runtime.
