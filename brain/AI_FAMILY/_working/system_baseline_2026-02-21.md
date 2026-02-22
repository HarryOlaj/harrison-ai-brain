# System Baseline — 2026-02-21

- Runtime repo commit (up360-ai-workroom): 58bd004
- Brain repo commit: 79b2bd3
- OpenClaw version: 2026.2.19-2
- Model in use: gpt-5.3-codex (openai-codex/gpt-5.3-codex)

## Active channel routing map
- #main → business=SYSTEM, agent_name=AI Harry
- #up360 → business=UP360, agent_name=VR Harry
- #earth-island-homes → business=EarthIsland, agent_name=Earth Harry
- #realestate → business=RealEstate, agent_name=House Harry

## Cron jobs configured
- healthcheck:security-audit (weekly)
- healthcheck:update-status (weekly)
- auth-expiry-check (daily 08:00 America/Halifax)
- nightly-usage-delta (daily 21:30 America/Halifax)
- daily-feedback-loop (daily 20:00 America/Halifax)
- state-of-system-dm (daily 21:30 America/Halifax, DM-only delivery)

## Known constraints
- approval_required=true on created orchestrator tasks
- runtime execution remains approval-gated
- no runtime engine code modifications unless explicitly approved
- schema modifications are forbidden unless explicitly approved

## Intentionally NOT implemented yet
- No automatic deletion/quarantine enforcement (policy only)
- No runtime retention sweeper that moves/deletes files on schedule
- No cross-channel broadcast for nightly system notes (DM-only policy)
- No schema migration for legacy untagged tasks beyond approved flows
