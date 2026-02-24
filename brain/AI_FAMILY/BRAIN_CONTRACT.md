# BRAIN_CONTRACT.md

- Canonical brain repo path: `C:\ai_ops\harrison-ai-brain` (Windows) / `/Users/aiharry/ai_ops/harrison-ai-brain` (Mac).
- Rule: runtime workspace is non-canonical; canonical updates go to the brain repo.
- Required domain set: `AI_FAMILY`, `PAM`, `UP360`, `Personal`, `EIH`, `RealEstate`.
- Missing domains are tracked as backlog items, not created ad hoc.
- Update cadence: nightly review queue, weekly domain backfill.
- Gate B: any "connected" claim requires `LIGHT_OK` proof.
- Execution authority: Jimmy is review-only unless explicitly delegated with `DELEGATE TO JIMMY: <bounded task>`.
