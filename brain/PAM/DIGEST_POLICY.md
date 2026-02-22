# DIGEST_POLICY

## Policy
1. Always generate a local daily digest file.
2. Commit digest only when meaningful changes are detected.
3. If no meaningful changes, write "no material updates" locally and skip commit.

## Digest Location
- Local generation target: `brain/PAM/digests/YYYY-MM-DD.md`

## Meaningful Change Criteria (Commit Eligible)
A digest is commit-eligible when at least one occurred:
- Key household event requiring continuity.
- Task created/completed with follow-up impact.
- Calendar change with downstream implications.
- Decision recorded that affects future behavior.
- Open loop requiring next-day action.

## Not Meaningful (Do Not Commit)
- No-op status checks.
- Duplicate events with no new outcome.
- Purely transient notifications.

## Required Pre-Commit Gate
Apply `REDACTION_POLICY.md` commit checklist before any digest commit.
