#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${1:-$HOME/.openclaw/workspace/config/jimmy-link.env}"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing env file: $ENV_FILE" >&2
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

exec ssh -N \
  -L "${LOCAL_PORT}:${REMOTE_HOST}:${REMOTE_PORT}" \
  -p "${SSH_PORT}" \
  -i "${SSH_KEY_PATH}" \
  ${SSH_OPTS} \
  "${SSH_USER}@${SSH_HOST}"
