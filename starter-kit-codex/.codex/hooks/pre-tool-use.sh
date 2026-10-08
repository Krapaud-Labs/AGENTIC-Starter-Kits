#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
config="$root/.codex"
input="$(cat)"
if ! printf '%s' "$input" | jq -e . >/dev/null 2>&1; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Événement hook JSON invalide."}}\n'
  exit 0
fi
tool="$(printf '%s' "$input" | jq -r '.tool_name // empty' 2>/dev/null || true)"
state="$config/RUNTIME-STATE.md"
if [ ! -f "$state" ]; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"RUNTIME-STATE.md absent. Initialiser le kit avant toute action."}}\n'
  exit 0
fi
native="$(sed -n 's/^- native_goal_status: //p' "$state" | head -1)"
next="$(sed -n 's/^- next_action: //p' "$state" | head -1)"
execution="$(sed -n 's/^- execution_status: //p' "$state" | head -1)"
goal="$(sed -n 's/^- goal_status: //p' "$state" | head -1)"
session="$(sed -n 's/^- session_status: //p' "$state" | head -1)"
case "$tool" in
  Bash|apply_patch|Edit|Write|Agent)
    if [[ "$native" == "required" || "$native" == "none" || "$next" == *A_COMPLETER* || -z "$next" || "$execution" == "blocked" || "$execution" == "needs-review" || "$goal" == "none" && "$session" != "not-required" ]]; then
      printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Action bloquée : état runtime, Goal ou prochaine action incohérents."}}\n'
      exit 0
    fi
    ;;
esac
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Contrat agentic contrôlé avant %s."}}\n' "${tool:-outil}"
