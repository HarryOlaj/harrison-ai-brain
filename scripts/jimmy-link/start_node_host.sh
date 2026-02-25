#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${1:-$HOME/.openclaw/workspace/config/jimmy-link.env}"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing env file: $ENV_FILE" >&2
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

cd "$WORKDIR"
export GATEWAY_TOKEN
export GATEWAY_URL

exec "$NODE_BIN" "$NODE_ENTRY"
