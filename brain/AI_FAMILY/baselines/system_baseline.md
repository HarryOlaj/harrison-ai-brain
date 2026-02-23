# System Baseline Snapshot

- Runtime repo commit hash (up360-ai-workroom): f2d7963
- Brain repo commit hash (harrison-ai-brain): aadde6c
- OpenClaw version: 2026.2.21-2
- Current model: openai-codex/gpt-5.3-codex

## Discord allowlisted channel IDs + policy
```json
{
  "groupPolicy": "allowlist",
  "guilds": [
    {
      "guild_id": "1474063511176085535",
      "channels": [
        "1474063701530251284",
        "1474950396593049683",
        "1474950478201884743",
        "1474950611635015750"
      ],
      "requireMention": false
    }
  ]
}
```

## Active cron jobs (ids + purpose)
```json
[
  {
    "id": "e41afe84-8016-4dfc-bd9b-f3a08118677e",
    "name": "healthcheck:security-audit",
    "purpose": "Run read-only security audit now: openclaw security audit --deep. Summarize warnings and add note: 'If fixes are needed, ask me to run healthcheck.'"
  },
  {
    "id": "dacf694b-2c47-4e76-9b64-60a1cfe490da",
    "name": "healthcheck:update-status",
    "purpose": "Run read-only version check now: openclaw update status. Summarize current channel and available updates."
  },
  {
    "id": "8ab11fee-db35-4645-88a5-74239b5efe5d",
    "name": "auth-expiry-check",
    "purpose": "Run `openclaw models status --check` via exec. If non-zero, report ALERT with exact error and impacted provider; if zero, report OK."
  },
  {
    "id": "7c5ab511-3e79-46ae-b1aa-c8d3ab85c3de",
    "name": "nightly-usage-delta",
    "purpose": "Collect session_status and openclaw status summary; report token/context usage and note change vs previous run if available."
  },
  {
    "id": "ad1f07f5-a3d3-486b-8f29-21348aac4949",
    "name": "daily-feedback-loop",
    "purpose": "Daily feedback loop check-in. Do setup scan first. Then provide exactly: 1 major improvement, 2 minor improvements, 1 relationship improvement, 1 human-action i"
  },
  {
    "id": "09ac11b3-e026-434e-a2ae-175f93fcfde2",
    "name": "state-of-system-dm",
    "purpose": "Send a DM only (no cross-posting) with exactly this format: STATE OF SYSTEM \u2013 <date/time> Changed today: \u2022 \u2026 Pending approvals: \u2022 \u2026 Intentionally not executed: "
  },
  {
    "id": "f1aeacf3-087e-4b82-b6ae-72a3997e1f39",
    "name": "nightly-baseline-snapshot",
    "purpose": "Run this command exactly: ~/ai_ops/harrison-ai-brain/orchestrator/nightly_baseline_snapshot.sh Then reply in this DM with only: - baseline commit hash - 'Baseli"
  },
  {
    "id": "95008cef-59f0-4c98-ad68-034e2433fba1",
    "name": "reminder:tcc-permissions-checklist",
    "purpose": "Reminder: Run the macOS permissions checklist (Files & Folders + Full Disk Access) for OpenClaw/Terminal."
  },
  {
    "id": "1192a293-979c-4fd7-919a-131671bccb94",
    "name": "reminder:scan-revisit-0830",
    "purpose": "Reminder: revisit setup scan items (security posture decision, session hygiene, repo hygiene, and daily alignment check)."
  }
]
```

## Approval policy in effect
- approval_required=true for orchestrator-created tasks
- execution remains explicit-approval gated

## Not implemented yet
- automatic deletion/quarantine enforcement
- runtime cleanup sweeper actions
- schema migrations for legacy tasks without explicit approval
