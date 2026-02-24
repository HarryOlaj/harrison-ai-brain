# SCHEDULE CONTRACT v1

Canonical Location: /harrison-ai-brain/contracts/schedule_contract.md  
Owner: Harrison  
Authority: Explicit only. No silent schedule mutations.

---

## CORE RULES
1. Heartbeat is not reporting.  
   30m heartbeat = health check only.
2. Reporting is fixed-time only. No drift. No "about 9:35". Exact times.
3. Each job must declare:
   - Trigger time
   - Responsible agent
   - Output channel
   - Output format
   - Failure behavior
4. Any new recurring task requires:
   - Contract edit
   - Commit to brain repo
   - Confirmation in Discord

---

## DAILY STRUCTURE

### GLOBAL
- Timezone: America/Toronto
- All times 24h format
- Max scheduled reports per agent per day: Harry=3, Jimmy=2

---

## HARRY – OPERATOR
Role: Execution + system state authority

### 08:00 – Model Status Report
Output: Discord #harry-daily  
Format:
- Active model
- API health
- Token usage last 24h
- Cost estimate
- Errors detected

### 12:00 – Midday Drift Check
Output: Discord #harry-daily  
Format:
- Runtime alive?
- Disk usage
- Memory usage
- Tunnel status
- Any failed jobs

### 21:30 – Daily System Summary
Output: Discord #harry-daily  
Format:
1. System health
2. Jobs executed today
3. Failures
4. Pending risks
5. Suggested fixes (max 3 bullets)

### 21:35 – Baseline Snapshot
Action only. No DM unless failure.
- Save state snapshot
- Log git hash
- Store metrics

Failure behavior:
- If snapshot fails → immediate Discord alert

---

## JIMMY – CTO
Role: Oversight + architecture integrity

### 09:00 – Architecture Review Ping
Output: Discord #cto-review  
Format:
- Repo diffs last 24h
- Unauthorized runtime changes
- Schedule violations
- Security flags

### 18:00 – Stability Audit
Output: Discord #cto-review  
Format:
1. Infrastructure risks
2. Performance anomalies
3. Dependency updates available
4. Recommendation (Approve / Monitor / Escalate)

Failure behavior:
- If a scheduled Harry report is not posted within 10 minutes of trigger time, Jimmy must post a miss alert in #cto-review within 60 minutes.

---

## HEARTBEAT POLICY
Every 30 minutes both agents:
- Confirm runtime alive
- Confirm Discord reachable
- Confirm brain repo accessible

Heartbeat output: silent unless failure.

---

## ANTI-DRIFT RULES
1. No reminder-style jobs allowed.
2. No vague timing.
3. No “nudge” tasks.
4. No auto-expanding schedule.

---

## WHY THIS STRUCTURE WORKS
- Clear separation: Operator vs CTO
- Max scheduled outputs controlled per agent
- Nightly authority snapshot
- Explicit failure escalation
- No noisy chatter
