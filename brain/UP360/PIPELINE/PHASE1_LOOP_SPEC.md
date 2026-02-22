# PHASE1_LOOP_SPEC

## Phase
A — System Validation Day (Draft-Only)

## Objective
Validate controlled "Playing Monopoly" architecture discipline for UP360 using historical lead outputs without external sending.

## Exact Input
- Source business: UP360
- Source file: `orgs_ranked_v3.csv` (or explicitly approved v3 equivalent)
- Input selection rule for each run:
  - Fixed, pre-declared row slice per run (e.g., rows 1–10, 11–20, 21–30)
  - No ad hoc row changes after run start without explicit approval

## Draft-Only Process (Tomorrow)
1. Create task packet with required fields:
   - `business=UP360`
   - `agent_name` set by channel routing
   - `approval_required=true`
   - objective references this Phase 1 spec
2. Generate outreach drafts only (no external send actions).
3. For each draft, append required self-critique using `DRAFT_QUALITY_CHECKLIST.md`.
4. Record each run in `LOOP_LEDGER.md`.
5. Store outputs in approved working location; no raw transcript commits.

## Approval Gate
A draft is eligible for approval request only if:
- Checklist is fully completed.
- Self-critique section is present.
- Approval line references task identifier (`task_id` or approved equivalent).
- No compliance/tone blockers are marked unresolved.

Approval outcome rules:
- If approved: draft marked "approved_for_manual_send".
- If not approved: revise and re-submit; no send.

## Manual Send Step (Defined, Not Executed Tomorrow)
Phase 1.5 manual send procedure:
1. Select exactly one approved draft.
2. Human reviews final copy.
3. Human performs manual send through controlled channel.
4. Log send event and downstream outcomes in `LOOP_LEDGER.md`.

Constraint:
- No auto-send path.
- No worker-triggered outbound messaging.

## Success Criteria for A (System Validation)
A is successful only if all are true:
1. Task created via Discord in `#up360` context.
2. Correct `business + agent_name` tagging present.
3. Approval flow used for all draft outputs.
4. Worker execution logged with proof artifacts.
5. Drafts are structured and checklist-complete.
6. No manual JSON edits required.
7. No runtime errors during loop.
8. No hygiene drift (naming, folder, or policy violations).
9. Run entries completed in `LOOP_LEDGER.md`.

## Stop Conditions
Stop immediately and escalate if any occur:
- Approval bypass attempt
- Runtime error affecting output integrity
- Missing proof logs
- Unclear compliance risk in draft content
- Ambiguous source-file provenance
