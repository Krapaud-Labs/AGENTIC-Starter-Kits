#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
state="$(cd "$script_dir/.." && pwd)/RUNTIME-STATE.md"

fail() { echo "GARDE REPONSE: $*" >&2; exit 1; }
[ -f "$state" ] || fail "RUNTIME-STATE.md absent"

value() { sed -n "s/^-[[:space:]]*$1:[[:space:]]*//p; s/^$1:[[:space:]]*//p" "$state" | head -n 1; }
status="$(value execution_status)"
next="$(value next_action)"
open="$(value open_checklist_items)"
evidence="$(value last_observable_evidence)"
ci="$(value ci_status)"; trello="$(value trello_sync_status)"
attempts="$(value attempt_count)"; max_attempts="$(value max_attempts)"; redundant="$(value redundant_confirmation_requested)"
required="$(value required_action_status)"; budget="$(value budget_status)"; environment="$(value environment_status)"; shutdown="$(value environment_shutdown_status)"; pending_request="$(value pending_request_id)"; pending_turn="$(value pending_turn_id)"
goal_status="$(value goal_status)"; goal_delivery="$(value goal_delivery_status)"; integration_branch="$(value integration_branch)"; pushed_commit="$(value pushed_integration_commit)"; remote_evidence="$(value integration_remote_evidence)"; pr_status="$(value pull_request_status)"
agents_created="$(value goal_agents_created)"; agent_evidence="$(value goal_agent_evidence)"
turn_status="$(value last_turn_status)"; tool_failures="$(value tool_failures)"; session_status="$(value session_status)"

case "$status" in
  complete)
    if [[ "$goal_status" != "none" && "$goal_status" != "not-required" ]]; then
      [[ "$goal_status" == "complete" ]] || fail "goal encore actif: $goal_status"
      [[ "$goal_delivery" == "verified" ]] || fail "livraison du goal non prouvée: $goal_delivery"
      [[ "$integration_branch" =~ ^(dev|develop)$ ]] || fail "branche d'intégration absente ou invalide: $integration_branch"
      [[ -n "$pushed_commit" && "$pushed_commit" != "none" && "$pushed_commit" != *"A_COMPLETER"* ]] || fail "commit poussé vers l'intégration absent"
      [[ "$pr_status" == "verified" ]] || fail "PR d'intégration non fusionnée ou branche distante non relue: $pr_status"
      [[ -n "$remote_evidence" && "$remote_evidence" != "none" && "$remote_evidence" != *"A_COMPLETER"* ]] || fail "preuve de mise à jour de la branche distante absente"
      [[ -n "$agents_created" && "$agents_created" != "none" && "$agents_created" != *"A_COMPLETER"* ]] || fail "agents du Goal non enregistrés"
      [[ -n "$agent_evidence" && "$agent_evidence" != "none" && "$agent_evidence" != *"A_COMPLETER"* ]] || fail "preuves des livrables agents absentes"
    fi
    [[ "$next" =~ ^(none|aucune|aucun)$ ]] || fail "next_action reste ouverte: $next"
    [[ "$open" =~ ^(0|none|aucune|aucun)$ ]] || fail "open_checklist_items non nul: $open"
    [[ -n "$evidence" && "$evidence" != *"A_COMPLETER"* ]] || fail "last_observable_evidence absente"
    [[ "$ci" =~ ^(success|verified|not-applicable)$ ]] || fail "CI non prouvée: $ci"
    [[ "$trello" =~ ^(verified|disabled|not-applicable)$ ]] || fail "Trello non relu: $trello"
    [[ "$attempts" =~ ^[0-9]+$ && "$max_attempts" =~ ^[0-9]+$ && "$attempts" -le "$max_attempts" ]] || fail "limite de tentatives dépassée"
    [[ "$redundant" != "yes" ]] || fail "confirmation redondante enregistrée"
    [[ "$required" =~ ^(none|resolved|not-required)$ ]] || fail "action requise non traitée: $required"
    [[ "$budget" =~ ^(not-applicable|within-limit|verified)$ ]] || fail "budget non vérifié: $budget"
    [[ "$environment" =~ ^(not-required|connected|safe|stopped)$ ]] || fail "environnement non vérifié: $environment"
    [[ "$shutdown" =~ ^(not-required|safe|complete)$ ]] || fail "arrêt environnement non vérifié: $shutdown"
    [[ "$pending_request" =~ ^(none|resolved)$ && "$pending_turn" =~ ^(none|resolved)$ ]] || fail "requête ou tour encore en attente"
    [[ "$turn_status" =~ ^(completed|verified|not-applicable)$ ]] || fail "dernier tour non vérifié: $turn_status"
    [[ "$tool_failures" =~ ^0$ ]] || fail "échec outil non traité: $tool_failures"
    [[ "$session_status" =~ ^(idle|completed|not-required)$ ]] || fail "session non vérifiée: $session_status"
    obligations="$script_dir/validate-obligations.sh"
    if [ -x "$obligations" ]; then
      bash "$obligations" --if-present >/dev/null || fail "obligations non vérifiées"
    fi
    ;;
  needs-review|blocked)
    [[ -n "$evidence" && "$evidence" != *"A_COMPLETER"* ]] || fail "preuve obligatoire absente pour $status"
    [[ -n "$next" && ! "$next" =~ ^(none|aucune|aucun)$ ]] || fail "next_action absente pour $status"
    recovery="$script_dir/verify-recovery-state.sh"
    [ -x "$recovery" ] && bash "$recovery" || fail "blocage récupérable ou état de reprise invalide"
    ;;
  running|waiting-ci) fail "état non terminal: $status" ;;
  *) fail "execution_status absent ou invalide: ${status:-absent}" ;;
esac

echo "Garde réponse OK: état terminal $status"
