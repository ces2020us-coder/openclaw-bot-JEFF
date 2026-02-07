#!/bin/bash
set -e

CONFIG_PATH="/root/.openclaw/openclaw.json"

mkdir -p /root/.openclaw/{logs,data,skills,workspace,credentials} \
  /root/.openclaw/agents/main/sessions

if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
  sed -i "s|\${ANTHROPIC_API_KEY}|${ANTHROPIC_API_KEY}|g" "$CONFIG_PATH"
fi

if grep -q '\${OPENCLAW_GATEWAY_TOKEN}' "$CONFIG_PATH"; then
  if [ -z "${OPENCLAW_GATEWAY_TOKEN:-}" ]; then
    OPENCLAW_GATEWAY_TOKEN="$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")"
    export OPENCLAW_GATEWAY_TOKEN
    echo "Generated OPENCLAW_GATEWAY_TOKEN (set this in Render env to keep it stable): ${OPENCLAW_GATEWAY_TOKEN}"
  fi
  sed -i "s|\${OPENCLAW_GATEWAY_TOKEN}|${OPENCLAW_GATEWAY_TOKEN}|g" "$CONFIG_PATH"
fi

echo "🦞 OpenClaw Bot starting on port ${PORT:-10000}..."
openclaw onboard --install-daemon 2>/dev/null || true

if [ "$#" -gt 0 ]; then
  exec "$@"
fi

exec openclaw gateway --port "${PORT:-10000}" --verbose
