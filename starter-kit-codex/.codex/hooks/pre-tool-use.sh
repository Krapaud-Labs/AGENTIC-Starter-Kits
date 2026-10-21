#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
config="$root/.codex"
input="$(cat)"
if ! printf '%s' "$input" | jq -e . >/dev/null 2>&1; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Événement hook JSON invalide."}}\n'
  exit 0
fi
tool_name="$(printf '%s' "$input" | jq -r '.tool_name // empty')"
command_text="$(printf '%s' "$input" | jq -r '.command // .arguments.command // empty')"
if [ -x "$config/scripts/is-recovery-command.sh" ] && bash "$config/scripts/is-recovery-command.sh" "$tool_name" "$command_text"; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Commande de récupération autorisée pour réparer l’état sans contourner les contrôles de livraison."}}\n'
  exit 0
fi
if [ "$tool_name" = "Bash" ] && [ "$command_text" = "bash .codex/scripts/sync-workspace-kit.sh" ]; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Synchroniseur du kit autorisé pour rétablir la porte de session."}}\n'
  exit 0
fi
if [ "$tool_name" = "Bash" ] && [ "$command_text" = "bash .codex/scripts/reconcile-runtime.sh" ]; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Réconciliation runtime autorisée avant la reprise; exécuter la commande puis relire l état."}}\n'
  exit 0
fi
if [ "$tool_name" = "Bash" ] && [[ "$command_text" =~ ^bash[[:space:]]+\.codex/scripts/resolve-user-input\.sh[[:space:]]+[A-Za-z0-9._-]+[[:space:]]+[^[:space:]]+$ ]]; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Résolveur de réponse utilisateur autorisé pour réconcilier la demande en attente."}}\n'
  exit 0
fi
if [ ! -f "$config/.session-kit-validated" ]; then
  if [ -x "$config/scripts/session-start-gate.sh" ] && bash "$config/scripts/session-start-gate.sh" >/dev/null 2>"$config/.session-kit-bootstrap-error"; then
    rm -f "$config/.session-kit-bootstrap-error"
  else
    if [ -f "$config/RUNTIME-STATE.md" ] && grep -q '^- execution_status: waiting-for-user$' "$config/RUNTIME-STATE.md"; then
      request_id="$(sed -n 's/^- pending_request_id: //p' "$config/RUNTIME-STATE.md" | head -1)"
      required_action="$(sed -n 's/^- required_action_status: //p' "$config/RUNTIME-STATE.md" | head -1)"
      if [ "$request_id" = "none" ] || [ "$required_action" != "pending" ]; then
        printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Aucun input utilisateur en attente; reprise autorisée malgré l’état waiting-for-user résiduel."}}\n'
        exit 0
      fi
      printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Question utilisateur en attente (%s). Exécuter immédiatement bash .codex/scripts/resolve-user-input.sh %s <reponse>, puis reprendre next_action."}}\n' "$request_id" "$request_id"
      exit 0
    fi
    reason="Porte kit non validée : réamorçage automatique impossible."
    [ -s "$config/.session-kit-bootstrap-error" ] && reason="$(tr '\n' ' ' < "$config/.session-kit-bootstrap-error")"
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$reason"
    exit 0
  fi
fi
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
if [ "$execution" = "waiting-for-user" ] || [ "$session" = "waiting-for-user" ]; then
  request_id="$(sed -n 's/^- pending_request_id: //p' "$state" | head -1)"
  required_action="$(sed -n 's/^- required_action_status: //p' "$state" | head -1)"
  if [ "$request_id" = "none" ] || [ "$required_action" != "pending" ]; then
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Aucun input utilisateur en attente; reprise autorisée malgré l’état waiting-for-user résiduel."}}\n'
    exit 0
  fi
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Question utilisateur en attente (%s). Exécuter immédiatement bash .codex/scripts/resolve-user-input.sh %s <reponse>, puis reprendre next_action."}}\n' "$request_id" "$request_id"
  exit 0
fi
case "$tool" in
  Bash|apply_patch|Edit|Write|Agent)
    if [[ "$native" == "required" || "$native" == "none" || "$next" == *A_COMPLETER* || -z "$next" || "$goal" == "none" && "$session" != "not-required" ]]; then
      printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Action bloquée : état runtime, Goal ou prochaine action incohérents."}}\n'
      exit 0
    fi
    if [[ "$execution" == "blocked" || "$execution" == "needs-review" ]]; then
      printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Mode récupération autorisé : réconcilier le runtime et reprendre le Goal avant toute livraison."}}\n'
    fi
    ;;
esac
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"Contrat agentic contrôlé avant %s."}}\n' "${tool:-outil}"
