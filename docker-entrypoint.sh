#!/bin/bash
set -e
mkdir -p /root/.openclaw/{logs,data,skills,workspace}
[ -n "$ANTHROPIC_API_KEY" ] && sed -i "s|\${ANTHROPIC_API_KEY}|${ANTHROPIC_API_KEY}|g" /root/.openclaw/openclaw.json
echo "🦞 OpenClaw Bot starting on port ${PORT:-10000}..."
openclaw onboard --install-daemon 2>/dev/null || true
exec openclaw gateway --port ${PORT:-10000} --verbose
