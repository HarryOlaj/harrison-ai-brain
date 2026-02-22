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
- `pam_api` (FastAPI webhook server)
- `pam_worker` (optional background worker for long tasks)

### Execution Model
1. Webhook receives SMS/MMS payload.
2. Request signature is validated.
3. Event is appended to audit log.
4. Intent router selects allowlisted handler.
5. Handler calls permitted tools (Google APIs, Drive).
6. Response text is generated.
7. Reply is sent via Twilio.

### Runtime Safety Baseline
- No shell execution.
- No git operations.
- No imports from Harry runtime.
- No business-repo reads/writes.

---

## 2) Exposure Model (Cloudflare Tunnel)

### Inbound Exposure
- PAM binds locally to loopback only (`127.0.0.1`).
- Cloudflare Tunnel provides public ingress for Twilio webhook delivery.
- Expose only webhook route required for Twilio.

### Policy
- No direct public bind on PAM process.
- Tunnel ingress narrowed to minimal path.

---

## 3) Twilio SMS/MMS Flow

### Inbound Inputs
- Sender phone number
- SMS text body
- Media URLs (MMS)
- Twilio Message SID (`MessageSid`)

### Outbound Outputs
- SMS response
- Optional summary + next-step format

### MMS Handling
- Download media URLs
- Store in Drive `Pam Notes/Inbox/Media/`
- Return link + short summary

---

## 4) Google Integration Staging

### Day 1 (Read + Create, no send)
- Gmail: read-only (both accounts)
- Calendar: read + create/update shared calendars
- Tasks: read/write
- Drive: read/write within dedicated PAM folder

### Week 1 (Controlled write escalation)
- Harrison Gmail: draft + send (send requires explicit confirmation)
- Wife Gmail: draft-only, no send

---

## 5) Secrets and Credential Isolation

### Secrets File
- `~/ai_ops/pam_runtime/.secrets.env`
- File permissions: `chmod 600`
- Never committed to git

### Expected Secret Keys
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
- `sender_phone`
- `provider_message_id`
- `inbound_text`
- `body_hash`
- `media_count`
- `media_urls`
- `detected_intent`
- `tools_called`
- `action_result`
- `reply_text`
- `error_type`
- `error_message`
- `retryable`

### Daily Digest
- `~/ai_ops/pam_runtime/logs/daily_digest_YYYY-MM-DD.md`

---

## 8) Permission Guardrails

### Explicit Confirmation Required
- Sending email
- Deleting anything
- Cancelling events

### Allowed Without Confirmation
- Creating draft email
- Creating task
- Suggesting time slots
- Capturing notes

---

## 9) Non-Negotiable Controls (v1)

### 1) Idempotency + Replay Protection (Critical)
- Reject duplicate processing using tuple:
  - `provider_message_id` (Twilio `MessageSid`)
  - `sender_phone`
  - `body_hash`
- Enforce signature timestamp validity window.

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

## 11) iPhone UX Model (SMS-First)

### Input Style
- Natural-language SMS/MMS commands

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
