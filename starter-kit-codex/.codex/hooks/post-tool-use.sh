#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/hook-runtime.sh"
event="$(cat)"
tool="$(printf '%s' "$event" | jq -r '.tool_name // "unknown"' 2>/dev/null || echo unknown)"
id="$(printf '%s' "$event" | jq -r '.tool_use_id // "unknown"' 2>/dev/null || echo unknown)"
if [ "$id" != "unknown" ] && grep -Fq "| id=$id" "$event_log" 2>/dev/null; then
  printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Événement déjà journalisé, aucune duplication créée."}}\n'
  exit 0
fi
log_event "$(date -u '+%Y-%m-%dT%H:%M:%SZ') | post_tool_use | tool=$tool | id=$id | status=$(printf '%s' "$event" | jq -r '.tool_response.status // "unknown"' 2>/dev/null || echo unknown)"
printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Preuve d’outil enregistrée pour %s."}}\n' "$tool"
