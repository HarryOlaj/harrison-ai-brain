# MEMORY.md

## Purpose
Canonical long-term memory for Harry + Harrison.

## Rules
- Keep entries short, factual, and dated.
- Store decisions, preferences, and active commitments.
- Do not store secrets/tokens/passwords.
- If a fact changes, add a new dated update (do not silently rewrite history).

## Identity & Working Preferences
- 2026-02-20: User prefers chatting primarily in Discord for day-to-day collaboration.
- 2026-02-20: User wants robust local memory so context survives outages/resets.
- 2026-02-20: Priority is reliability over feature breadth.
- 2026-02-23: User asks for a safety nudge after midnight to stop if they begin suggesting risky changes.
- 2026-02-23: GitHub account shown: `HarryOlaj`; primary email shown: `harrisonolajos32@gmail.com`.

## Decisions
- 2026-02-20: Establish local-first memory system using `MEMORY.md` + `memory/*.md` as source of truth.
- 2026-02-25: Jimmy↔Harry Windows link standardized on secure localhost tunnel topology (`127.0.0.1:18790 -> Harry gateway 127.0.0.1:18789`) with watchdog + task-based recovery; direct LAN `ws://` node host mode is disallowed by OpenClaw security.
- 2026-02-20: Discord remains active for chat, but critical context is mirrored into local memory files.
- 2026-02-23: Preferred multi-agent workflow is iterative: Agent A proposes initial design → Agent B suggests improvements → Agent A assesses and finalizes recommendations → Agent B implements/tests.
- 2026-02-23: User wants visible agent back-and-forth in Discord and a workflow extensible with future specialist agents (e.g., UX, security).
- 2026-02-23: Discord channel structure updated: `#workroom-1` for agent debate + final decisions (threaded), `#jimmy-cto` for Jimmy logs only.
- 2026-02-23: DMs remain primary for direct operator chat; tag Harrison only when blocked and ask at most one question.
- 2026-02-23: Discord server renamed to `Harry Industries`; server boosted for higher upload size limits.
- 2026-02-23: Jimmy persona preference: older Jimmy Neutron, elite coder CTO; relationship framing is Harrison as boss + friend, with Jimmy equity-aligned to Harry Industries.
- 2026-02-23: Operational routing decision: use Harry (OpenAI-codex auth path) as primary runtime now; keep Jimmy for Discord presence/logging and bounded delegated work.
- 2026-02-24: Default behavior update: never ask Harrison to perform an action the agent can do directly; ask for approval instead when required.
- 2026-02-24: Secrets manager preference clarified: use 1Password as the standard for auth tokens/password workflows.

## Current Risks
- 2026-02-20: Semantic memory search is degraded when embeddings quota is exhausted.

## Next Actions
- 2026-02-20: Maintain structured logs in `memory/` for continuity.
- 2026-02-20: Add periodic local backups of memory artifacts.
- 2026-02-20: Imported local Discord session transcripts to `memory/raw/discord/` for recovery-safe retention.
