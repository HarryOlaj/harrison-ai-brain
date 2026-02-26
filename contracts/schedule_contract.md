# SCHEDULE CONTRACT v2

Canonical Location: /harrison-ai-brain/contracts/schedule_contract.md
Owner: Harrison
Authority: Explicit only. No silent schedule mutations.

---

## CORE RULES
1. Heartbeat is not reporting.
   30m heartbeat = health check only, silent unless failure.
2. Reporting is fixed-time only. Exact times.
3. All scheduled posts go to: Sync Status thread/channel.
4. Any new recurring task requires:
   - Contract edit
   - Commit to brain repo
   - Confirmation in Discord

---

## GLOBAL
- Timezone: America/Halifax
- Time format: 24h

---

## REQUIRED CHECK-INS (EVERY DAY)

### Sync Status (each agent posts individually)
Times:
- 08:00
- 12:00
- 20:00

Format (exact 5 lines):
TOPLEVEL=
REMOTE=
BRANCH=
HEAD=
LASTCOMMIT=

Failure behavior:
- If preflight fails or repo unreachable, post:
ERROR=SYNC_FAIL <one-line reason>

### Health Status (each agent posts individually)
Times:
- 08:30
- 20:00

Format (single line):
HEALTH=OK gateway=<up/down> discord=<up/down> repo=<ok/fail> tunnel=<up/down> notes=<optional short>

Failure behavior:
- If HEALTH not OK, include: HEALTH=FAIL and one concrete next action.

---

## ALLOWED ESSENTIAL AUTOMATIONS (NO MORE)
1. Auto-start on boot/login for each agent runtime.
2. Self-heal to restore gateway connectivity (restart gateway task/service) on failure.
3. Tunnel/watchdog only if required for Harry<->Jimmy connectivity.

Everything else is disallowed unless added here explicitly.

---

## GIT STANDARD
- Only Harry merges/pushes to main.
- Jimmy and Pam work on branches only.
- Before any work or scheduled post, run preflight script:
  - Windows: powershell -ExecutionPolicy Bypass -File C:\ai_ops\preflight.ps1
  - Mac: /Users/aiharry/ai_ops/preflight.sh
