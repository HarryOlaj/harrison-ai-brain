#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${1:-$HOME/.openclaw/workspace/config/jimmy-link.env}"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing env file: $ENV_FILE" >&2
  exit 2
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

status=$(curl -sS -m "${GATE_B_TIMEOUT_SEC}" -o /dev/null -w "%{http_code}" "${GATE_B_CHECK_URL}" || true)
if [[ "$status" == "200" || "$status" == "204" ]]; then
  echo "gate_b=ok status=$status"
  exit 0
fi

echo "gate_b=fail status=${status:-none}"
exit 1
