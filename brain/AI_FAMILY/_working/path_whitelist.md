# path_whitelist

Allowed/expected path references (current baseline):

1. `Path.home()/".up360-workroom"/"keys"`
   - Used by:
     - `up360-ai-workroom/tools/approve.py`
     - `up360-ai-workroom/tools/worker.py`
   - Reason: local signing key location for approvals/worker verification.

2. `Path.home()/"up360-ai-workroom"`
   - Used by:
     - `up360-ai-workroom/tools/state_emitter.py`
     - `up360-ai-workroom/tools/discord_task_cli.sh` (embedded python)
   - Reason: local workroom root discovery.

3. `Path.home()/"ai_ops"/"harrison-ai-brain"`
   - Used by:
     - `harrison-ai-brain/orchestrator/channel_router.py`
   - Reason: brain root resolution in current repo layout.

4. `Path.home()/"ai_ops"/"up360-ai-workroom"/"tasks"`
   - Used by:
     - `harrison-ai-brain/orchestrator/channel_router.py`
   - Reason: task packet handoff path.

5. `Path.home()/".openclaw"/...`
   - Used by:
     - `harrison-ai-brain/orchestrator/nightly_baseline_snapshot.sh`
   - Reason: OpenClaw local runtime config and cron metadata reads.

Notes:
- Any additional absolute home-path assumptions outside this whitelist are unexpected and should be treated as FAIL until reviewed.
