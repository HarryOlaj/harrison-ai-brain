#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BRAIN_REPO="$(cd "$SCRIPT_DIR/.." && pwd)"
AI_OPS_ROOT="${AI_OPS_ROOT:-$(cd "$BRAIN_REPO/.." && pwd)}"
RUNTIME_REPO="$AI_OPS_ROOT/up360-ai-workroom"
BASELINE_FILE="$BRAIN_REPO/brain/AI_FAMILY/baselines/system_baseline.md"
OPENCLAW_HOME="${OPENCLAW_HOME:-$HOME/.openclaw}"

runtime_hash="$(git -C "$RUNTIME_REPO" rev-parse --short HEAD)"
brain_hash_before="$(git -C "$BRAIN_REPO" rev-parse --short HEAD)"
openclaw_ver="$(openclaw --version | head -n1)"
model="$(OPENCLAW_HOME="$OPENCLAW_HOME" python3 - <<'PY'
import json, os
from pathlib import Path
cfg=json.loads((Path(os.environ['OPENCLAW_HOME'])/'openclaw.json').read_text())
print(cfg.get('agents',{}).get('defaults',{}).get('model',{}).get('primary','unknown'))
PY
)"

discord_meta="$(OPENCLAW_HOME="$OPENCLAW_HOME" python3 - <<'PY'
import json, os
from pathlib import Path
cfg=json.loads((Path(os.environ['OPENCLAW_HOME'])/'openclaw.json').read_text())
d=cfg.get('channels',{}).get('discord',{})
policy=d.get('groupPolicy','unknown')
guilds=d.get('guilds',{})
out=[]
for gid,g in guilds.items():
    ch=sorted((g.get('channels') or {}).keys())
    out.append({'guild_id':gid,'channels':ch,'requireMention':g.get('requireMention')})
print(json.dumps({'groupPolicy':policy,'guilds':out},indent=2))
PY
)"

cron_meta="$(OPENCLAW_HOME="$OPENCLAW_HOME" python3 - <<'PY'
import json, os
from pathlib import Path
jobs=json.loads((Path(os.environ['OPENCLAW_HOME'])/'cron'/'jobs.json').read_text()).get('jobs',[])
rows=[]
for j in jobs:
    pid=(j.get('payload') or {})
    purpose=(pid.get('message') or pid.get('text') or '')
    purpose=' '.join(purpose.split())[:160]
    rows.append({'id':j.get('id'),'name':j.get('name'),'purpose':purpose})
print(json.dumps(rows,indent=2))
PY
)"

cat > "$BASELINE_FILE" <<EOF
# System Baseline Snapshot

- Runtime repo commit hash (up360-ai-workroom): $runtime_hash
- Brain repo commit hash (harrison-ai-brain): $brain_hash_before
- OpenClaw version: $openclaw_ver
- Current model: $model

## Discord allowlisted channel IDs + policy
\`\`\`json
$discord_meta
\`\`\`

## Active cron jobs (ids + purpose)
\`\`\`json
$cron_meta
\`\`\`

## Approval policy in effect
- approval_required=true for orchestrator-created tasks
- execution remains explicit-approval gated

## Not implemented yet
- automatic deletion/quarantine enforcement
- runtime cleanup sweeper actions
- schema migrations for legacy tasks without explicit approval
EOF

cd "$BRAIN_REPO"
git add brain/AI_FAMILY/baselines/system_baseline.md
git commit -m "baseline: system snapshot" >/dev/null
git push origin main >/dev/null
new_hash="$(git rev-parse --short HEAD)"

echo "BASELINE_COMMIT=$new_hash"
echo "Baseline saved: brain/AI_FAMILY/baselines/system_baseline.md"
