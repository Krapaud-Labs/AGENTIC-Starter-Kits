#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
config="$root/.claude"
input="$(cat)"
tool="$(printf '%s' "$input" | jq -r '.tool_name // empty' 2>/dev/null || true)"
state="$config/RUNTIME-STATE.md"
if [ ! -f "$state" ]; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"RUNTIME-STATE.md absent. Initialiser le kit avant toute action."}}\n'
  exit 0
fi
native="$(sed -n 's/^- native_goal_status: //p' "$state" | head -1)"
next="$(sed -n 's/^- next_action: //p' "$state" | head -1)"
case "$tool" in
  Bash|apply_patch|Edit|Write|Agent)
    if [[ "$native" == "required" || "$native" == "none" || "$next" == *A_COMPLETER* ]]; then
      printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Action bloquée : Goal natif, état runtime ou prochaine action non initialisés."}}\n'
      exit 0
    fi
    ;;
esac
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Contrat agentic contrôlé avant %s."}}\n' "${tool:-outil}"
