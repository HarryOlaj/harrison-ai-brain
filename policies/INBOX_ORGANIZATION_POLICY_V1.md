# Inbox Organization Policy V1 (Pam)

Owner: Harrison  
Operator: Pam  
Reviewer: Jimmy (one-pass review before production)  
Status: Draft V1 (aligned to final labels)

## Objective
Keep inbox low-noise and easy to act on each morning.

## Final Label Set (approved)
- `🔥 Urgent`
- `↩️ Needs-Reply`
- `🤝 Client-Comms`
- `💳 Receipt & Invoices`
- `📰 Low-Priority`

## Starred + Important Usage
- `Starred` = true action queue.
- `Important` = ignored (not used for routing decisions).

## Routing Rules
1. **Client communications**
   - If sender is client/prospect/vendor allowlist → apply `🤝 Client-Comms`.
   - If the email asks for response/decision → add `↩️ Needs-Reply`.

2. **Urgency**
   - Add `🔥 Urgent` only when same-day action is required.
   - Auto-star all `🔥 Urgent`.

3. **Needs-Reply starring**
   - If `↩️ Needs-Reply` + `🤝 Client-Comms` → star it.

4. **Finance**
   - Receipts/invoices/orders/credit memos/payment confirmations → `💳 Receipt & Invoices`.
   - Not starred unless action required.

5. **Low-Priority**
   - Newsletters/promotions/non-critical updates/security routine notices → `📰 Low-Priority`.
   - Auto-archive allowed.

## Security Handling (per Harrison preference)
Default: security emails go to `📰 Low-Priority`.

Exceptions (promote to `🔥 Urgent` + star):
- New login from unknown location/device
- Password reset not requested
- MFA/recovery method changed
- Account lockout or billing/security hold requiring action

## Daily Morning Routine (Pam)
Run once each morning (target 08:30 America/Halifax):
1) Scan new mail (last 24h)
2) Apply labels/rules above
3) Archive low-priority noise
4) Keep urgent + starred visible
5) Send compact daily brief

### Daily Brief Template
- Urgent: <count> (top 3)
- Needs-Reply: <count> (top 5 oldest first)
- Client-Comms: <count>
- Receipt & Invoices: <count>
- Low-Priority archived: <count>
- Uncertain items: <count> (with list)

## Safety
- No auto-delete.
- Uncertain classification must be surfaced in daily brief.

---

## Harrison Setup Steps (your side)
1. Create these labels exactly in Gmail:
   - 🔥 Urgent
   - ↩️ Needs-Reply
   - 🤝 Client-Comms
   - 💳 Receipt & Invoices
   - 📰 Low-Priority

2. Share allowlists:
   - Client/prospect domains
   - Important contacts
   - Known finance senders

3. Confirm archive policy:
   - `📰 Low-Priority` auto-archive = yes/no

4. Confirm run window:
   - Daily at 08:30 AST (or specify preferred time)

5. Pilot for 5 days in supervised mode:
   - Review false positives and tune.

---

## Jimmy Review Checklist (one pass)
- Rules deterministic and low-noise
- Starring logic matches "action queue" intent
- Low-priority + security exception handling is safe
- Daily brief is decision-ready in under 60 seconds
