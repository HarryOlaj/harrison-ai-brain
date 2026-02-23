# PAM_SPEC_V1

## Purpose
Define the technical architecture, safety boundaries, and operational controls for PAM v1.

## Scope
PAM v1 handles life-layer operations only:
- Gmail
- Calendar
- Tasks
- Notes/Drive

PAM v1 does **not** access:
- UP360 repos
- Business repos
- HubSpot
- ClickUp business spaces
- Shell/terminal execution

---

## 1) Runtime Topology (Same-Mac Model)

### Location
- `~/ai_ops/pam_runtime/`

### Services
- `pam_api` (FastAPI service boundary)
- `pam_worker` (optional background worker for long tasks)
- `pam_discord_adapter` (Discord DM adapter, separate token)
- `pam_twilio_adapter` (Twilio SMS/MMS webhook adapter)

### Adapter Pattern (Dual Interface Model)
PAM v1 supports two inbound adapters:
1. Discord DM (primary interface now)
2. Twilio SMS/MMS (secondary, next rollout)

Both adapters must route into the **same shared intent layer**.
No duplicate intent logic is allowed across adapters.

### Execution Model
1. Adapter receives inbound event (Discord DM or Twilio webhook).
2. Adapter validates source/auth requirements.
3. Adapter writes normalized event to append-only audit log.
4. Shared intent router selects allowlisted handler.
5. Handler calls permitted tools (Google APIs, Drive).
6. Response text is generated.
7. Adapter sends channel-appropriate reply.

### Runtime Safety Baseline
- No shell execution.
- No git operations.
- No imports from Harry runtime.
- No business-repo reads/writes.
- PAM runtime remains standalone and is not integrated into OpenClaw.

---

## 2) Exposure Model (Cloudflare Tunnel)

### Inbound Exposure
- PAM binds locally to loopback only (`127.0.0.1`).
- Cloudflare Tunnel provides public ingress for Twilio webhook delivery.
- Expose only webhook route required for Twilio.
- Discord adapter uses outbound gateway connection and DM events only (no server-channel handling).

### Policy
- No direct public bind on PAM process.
- Tunnel ingress narrowed to minimal path.
- Discord adapter must ignore all guild/server channels and respond in DMs only.

---

## 3) Interface Adapters

### A) Discord DM Adapter (Primary for v1 rollout)
#### Requirements
- Uses a separate PAM Discord bot token.
- Responds to DMs only.
- Ignores all server/guild channels.
- Logs events to the shared `events.jsonl` audit file.
- Enforces kill switch behavior.
- Enforces intent allowlist.
- Enforces rate limits.

#### Inbound Inputs
- Sender user ID
- DM text
- Message ID
- Attachments metadata (if present)

#### Outbound Outputs
- DM response
- Optional summary + next-step format

### B) Twilio SMS/MMS Adapter (Secondary, next rollout)
#### Inbound Inputs
- Sender phone number
- SMS text body
- Media URLs (MMS)
- Twilio Message SID (`MessageSid`)

#### Outbound Outputs
- SMS response
- Optional summary + next-step format

#### MMS Handling
- Download media URLs
- Store in Drive `Pam Notes/Inbox/Media/`
- Return link + short summary

---

## 4) Google Integration Model (Policy-Layer Controlled)

PAM is not restricted by fragmented calendar/account write permissions.
PAM has read/write access across relevant Google Calendars to operate as an executive/personal assistant.
Safety is enforced via policy-layer action classes (not by narrow account capability limits alone).

### Base Access
- Gmail: read/write as configured for life-layer operations
- Calendar: read/write across relevant calendars
- Tasks: read/write
- Drive: read/write within dedicated PAM folders

### Hard Boundary
- Business-system actions remain gated by policy and approval classes.

---

## 5) Secrets and Credential Isolation

### Secrets File
- `~/ai_ops/pam_runtime/.secrets.env`
- File permissions: `chmod 600`
- Never committed to git

### Expected Secret Keys
- `DISCORD_BOT_TOKEN_PAM`
- `TWILIO_ACCOUNT_SID`
- `TWILIO_AUTH_TOKEN`
- `TWILIO_NUMBER`
- `GOOGLE_OAUTH_CLIENT_ID`
- `GOOGLE_OAUTH_CLIENT_SECRET` (or credential path)
- `TOKEN_STORE_PATH`

### Isolation Rule
- PAM secrets namespace is fully separate from Harry secrets.
- PAM runtime must not load Harry secret files.

---

## 6) Kill Switch Behavior

### Kill Switch File
- `~/ai_ops/pam_runtime/KILL_SWITCH`

### Behavior
If present:
- All write actions are blocked.
- Read-only operations may continue (optional policy per handler).
- Outbound response must indicate writes are paused (e.g., "Writes paused").

### Protected Write Actions
- Send email
- Delete operations
- Calendar cancellations
- Any irreversible mutation

---

## 7) Audit Logging Contract

### Event Log
- `~/ai_ops/pam_runtime/logs/events.jsonl`
- Append-only

### Per-Event Required Fields
- `timestamp`
- `adapter` (`discord_dm` | `twilio_sms`)
- `sender_id` (phone or Discord user ID)
- `provider_message_id`
- `inbound_text`
- `body_hash`
- `media_count`
- `media_urls`
- `detected_intent`
- `action_class` (`A` | `B` | `C`)
- `tools_called`
- `action_result`
- `reply_text`
- `error_type`
- `error_message`
- `retryable`

### Daily Digest
- `~/ai_ops/pam_runtime/logs/daily_digest_YYYY-MM-DD.md`
- High-signal only (not every action)
- Always include Class B and Class C actions
- Include significant Class A actions only (travel, medical, financial)

---

## 8) Action Class Policy Layer (Guardrails)

Safety and autonomy are enforced by action class, independent of raw account permission breadth.

### Class A — Auto-Execute
- Create new event in an empty slot
- Create tasks
- Add notes/reminders

### Class B — Confirm First
- Create event that overlaps another
- Modify event PAM created
- Change event time/date

### Class C — Explicit Approval Required
- Delete event
- Modify/cancel events created externally (e.g., business-origin meetings)
- Send business emails
- Cancel external meetings

### Execution Rule
- PAM must evaluate action class before execution.
- If class is B or C, follow confirmation/approval requirement strictly.

---

## 9) Non-Negotiable Controls (v1)

### 1) Idempotency + Replay Protection (Critical)
- Reject duplicate processing using tuple:
  - `adapter`
  - `provider_message_id` (Twilio `MessageSid` or Discord message ID)
  - `sender_id`
  - `body_hash`
- Enforce timestamp validity window for signed/webhook sources.

### 2) Timeout Budget + Async Handling
- Hard response budget: 4 seconds.
- If work exceeds budget:
  - Immediate ack: "Got it. Working on it."
  - Queue background job
  - Send follow-up SMS on completion

### 3) Error Taxonomy (Ops-Grade)
Every event must include:
- `error_type`: `auth_error | validation_error | tool_error | rate_limit | unknown`
- `error_message`
- `retryable` (true/false)

### 4) Deny-by-Default Intent Allowlist
Supported intents only (initial examples):
- add calendar event
- find next free time
- create task
- capture note
- summarize inbox

Unknown intent behavior:
- no tool calls
- safe response
- clarifying question

### 5) Outbound Rate Guards
- Per-sender throttles
- Cooldown window
- Loop detection for repeated content

### 6) Privacy Mode Toggle
- `privacy_mode=true`

When enabled:
- Avoid quoting email body verbatim in SMS
- Return summarized content instead

### 7) Log Rotation + Retention
- Rotate `events.jsonl` daily
- Keep 30 days local retention
- Optional encrypted backup later
- Never log secrets/tokens

---

## 10) Data Storage Layout

### Drive Root
- `Drive/Pam Notes/`

### Subfolders
- `Inbox/`
- `Family/`
- `Travel/`
- `School/`
- `Health/`
- `Receipts/` (optional later)

---

## 11) UX Model (Discord DM-First, SMS Secondary)

### Input Style
- Natural-language Discord DM commands (primary)
- Natural-language SMS/MMS commands (secondary)

### Output Style
- Short, action-oriented replies
- Optional summary + next steps
- Clarifying questions when intent confidence is low

---

## 12) Escalation Boundaries

Escalate to user confirmation when:
- irreversible action requested
- ambiguity impacts correctness/safety
- auth scope insufficient
- tool/API errors block execution path

---

## 13) Separation Boundary from Harry (Hard)

PAM is separate from Harry by design:
- Separate runtime directory
- Separate secrets
- Separate logs
- Separate process model
- No shell access
- No business repo access
- No business tool access

---

## 14) Cutover Trigger to Second Machine (Predefined)

Move PAM off same Mac to a second machine if any occur:
1. 1 unexpected crash in a week
2. Mac reboot causes state corruption
3. Cron fails twice consecutively
4. Memory conflicts detected
5. CPU sustained >60% during normal load

Cutover is automatic policy trigger (no debate at trigger point).
