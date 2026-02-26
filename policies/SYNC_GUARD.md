# SYNC_GUARD.md

Canonical repo: `C:\ai_ops\harrison-ai-brain`
Canonical branch: `main`

## Mandatory proof footer (all agent confirmations)
- `HEAD:<hash> CLEAN:<yes/no> WORKSPACE:C:\ai_ops\harrison-ai-brain`

## Pre-reply sync check
Before replying "confirmed/done":
1. `git rev-parse --short HEAD`
2. `git status --short`
3. If dirty or behind:
   - `git fetch origin`
   - `git checkout main`
   - `git reset --hard origin/main`

## Drift handling
If hash mismatch across Harry/Jimmy/Pam:
- Raise: `ESCALATE: repo drift detected`
- Halt non-critical actions until resynced.

## On-demand sync check trigger (channel use)
If Harrison asks in health-check channel with either trigger phrase:
- `SYNC_CHECK`
- `are we synced?`

Agents should run local sync verification and reply with:
- `RESULT:<PASS|FAIL> HEAD:<hash> CLEAN:<yes/no> WORKSPACE:C:\ai_ops\harrison-ai-brain`

If `FAIL`, include both lines:
- `AUTO_RESYNC: done|blocked`
- `FAIL_CONTEXT: <short root-cause/troubleshooting hint>`
