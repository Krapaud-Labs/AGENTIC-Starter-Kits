#!/usr/bin/env bash
set -euo pipefail
event="$(cat)"
command="$(printf '%s' "$event" | jq -r '.tool_input.command // empty' 2>/dev/null || true)"
if printf '%s' "$command" | grep -Eiq 'OPENAI_API_KEY|ANTHROPIC_API_KEY|ANTHROPIC_AUTH_TOKEN|CODEX_API_KEY|curl.*api\\.openai|curl.*api\\.anthropic|git push .* (main|master|dev|develop)|rm -rf'; then
  printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"deny","message":"Action refusée par le kit : API payante, branche protégée ou commande destructive détectée."}}}\n'
else
  printf '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}\n'
fi
