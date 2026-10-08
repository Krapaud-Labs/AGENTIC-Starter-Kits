#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
state="$(cd "$script_dir/.." && pwd)/RUNTIME-STATE.md"
[ -f "$state" ] || { echo "SESSION: RUNTIME-STATE.md absent" >&2; exit 1; }
value() { sed -n "s/^-[[:space:]]*$1:[[:space:]]*//p" "$state" | head -n 1; }
for key in execution_status next_action last_observable_evidence required_action_status pending_request_id pending_turn_id budget_status environment_status session_status native_goal_status native_goal_id native_goal_evidence; do
  v="$(value "$key")"
  [ -n "$v" ] && [[ "$v" != *A_COMPLETER* ]] || { echo "SESSION: champ absent ou incomplet: $key" >&2; exit 1; }
done
native_status="$(value native_goal_status)"
native_id="$(value native_goal_id)"
native_evidence="$(value native_goal_evidence)"
native_blocked_condition="$(value native_goal_blocked_condition)"
case "$native_status" in
  active) [ "$native_id" != "none" ] && [ -n "$native_evidence" ] || { echo "SESSION: Goal natif actif sans identifiant ou preuve" >&2; exit 1; } ;;
  unavailable) [ -n "$native_evidence" ] || { echo "SESSION: indisponibilité native sans preuve" >&2; exit 1; } ;;
  blocked) [ "$native_id" != "none" ] && [ -n "$native_evidence" ] && [ -n "$native_blocked_condition" ] || { echo "SESSION: Goal natif bloqué sans identifiant, preuve ou cause séparée" >&2; exit 1; } ;;
  *) echo "SESSION: native_goal_status invalide: $native_status" >&2; exit 1 ;;
esac
echo "État de session lisible et complet"
