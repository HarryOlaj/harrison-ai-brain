#!/usr/bin/env bash
set -euo pipefail

CHANNEL_ID="1475275671025488014"
NODE_ID="0d3213d4dfd75487ec9e19866acca25013f4efc341dbebfb2b76d5efd04fc0f1"
REPO="/Users/aiharry/.openclaw/workspace"
EXPECTED_MODEL="openai-codex/gpt-5.3-codex"
EXPECTED_WS='C:\\ai_ops\\harrison-ai-brain'

cd "$REPO"
H_HEAD=$(git rev-parse --short HEAD)
if [[ -z "$(git status --short)" ]]; then H_CLEAN=yes; else H_CLEAN=no; fi

J_OUT=$(openclaw nodes run --node "$NODE_ID" --raw "cd /d C:\\ai_ops\\harrison-ai-brain && for /f %i in ('git rev-parse --short HEAD') do @echo J_HEAD:%i" || true)
J_HEAD=$(printf "%s" "$J_OUT" | sed -n 's/.*J_HEAD:\([0-9a-f]\{7,\}\).*/\1/p' | tail -n1)
[[ -z "$J_HEAD" ]] && J_HEAD="unknown"

P_OUT=$(openclaw nodes run --node "$NODE_ID" --raw "openclaw.cmd --profile pam config get agents.defaults.model.primary && openclaw.cmd --profile pam config get agents.defaults.workspace" || true)
P_MODEL=$(printf "%s" "$P_OUT" | sed -n 's/.*\(openai-codex\/gpt-5\.3-codex\).*/\1/p' | tail -n1)
[[ -z "$P_MODEL" ]] && P_MODEL="unknown"
P_WS=$(printf "%s" "$P_OUT" | sed -n 's#.*\(C:\\\\ai_ops\\\\harrison-ai-brain\).*#\1#p' | tail -n1)
[[ -z "$P_WS" ]] && P_WS="unknown"

RESULT="PASS"
AUTO_RESYNC="n/a"
FAILS=()

if [[ "$J_HEAD" == "unknown" ]]; then
  RESULT="FAIL"
  AUTO_RESYNC="blocked"
  FAILS+=("Jimmy node unreachable or git head unavailable")
elif [[ "$J_HEAD" != "$H_HEAD" ]]; then
  RESULT="FAIL"
  AUTO_RESYNC="blocked"
  FAILS+=("Repo drift detected (Harry:$H_HEAD Jimmy:$J_HEAD)")
fi

if [[ "$P_MODEL" != "$EXPECTED_MODEL" ]]; then
  RESULT="FAIL"
  AUTO_RESYNC="blocked"
  FAILS+=("Pam model mismatch (got:$P_MODEL expected:$EXPECTED_MODEL)")
fi

if [[ "$P_WS" != "$EXPECTED_WS" ]]; then
  RESULT="FAIL"
  AUTO_RESYNC="blocked"
  FAILS+=("Pam workspace mismatch (got:$P_WS expected:$EXPECTED_WS)")
fi

if [[ "$H_CLEAN" != "yes" ]]; then
  RESULT="FAIL"
  AUTO_RESYNC="blocked"
  FAILS+=("Harry workspace dirty")
fi

MSG="SYNC_REPORT RESULT:${RESULT} HARRY:${H_HEAD}/${H_CLEAN} JIMMY:${J_HEAD} PAM_MODEL:${P_MODEL} PAM_WS:${P_WS} GIT_COMMIT:${H_HEAD}"
if [[ "$RESULT" == "FAIL" ]]; then
  FAIL_CONTEXT=$(IFS=' | '; echo "${FAILS[*]}")
  MSG+=" AUTO_RESYNC:${AUTO_RESYNC} FAIL_CONTEXT:${FAIL_CONTEXT}"
fi

openclaw message send --channel discord --target "$CHANNEL_ID" --message "$MSG" >/dev/null

echo "$MSG"
