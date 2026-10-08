#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
event="$(cat)"
tool="$(printf '%s' "$event" | jq -r '.tool_name // "unknown"' 2>/dev/null || echo unknown)"
id="$(printf '%s' "$event" | jq -r '.tool_use_id // "unknown"' 2>/dev/null || echo unknown)"
if [ "$id" != "unknown" ] && grep -Fq "| id=$id" "$root/.claude/runtime-events.log" 2>/dev/null; then
  printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Événement déjà journalisé, aucune duplication créée."}}\n'
  exit 0
fi
printf '%s | post_tool_use | tool=%s | id=%s | status=%s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$tool" "$id" "$(printf '%s' "$event" | jq -r '.tool_response.status // "unknown"' 2>/dev/null || echo unknown)" >> "$root/.claude/runtime-events.log"
printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Preuve d’outil enregistrée pour %s."}}\n' "$tool"
