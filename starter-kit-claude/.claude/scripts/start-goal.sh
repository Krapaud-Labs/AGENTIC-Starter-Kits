#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 4 ] || [ "$#" -gt 9 ]; then
  echo "Usage: $0 OBJECTIF VERIFICATION CONTRAINTES CONDITION_BLOCAGE [CARTE] [BRANCHE] [DELEGATION] [AGENTS] [AFFECTATIONS]" >&2
  exit 2
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
state="$config/RUNTIME-STATE.md"
events="$config/runtime-events.log"
[ -f "$state" ] || { echo "GOAL: RUNTIME-STATE.md absent" >&2; exit 1; }

native_status="${NATIVE_GOAL_STATUS:-}"
native_id="${NATIVE_GOAL_ID:-none}"
native_evidence="${NATIVE_GOAL_EVIDENCE:-}"
case "$native_status" in
  active)
    [ "$native_id" != "none" ] && [ -n "$native_evidence" ] || { echo "GOAL: preuve, identifiant et état actif du Goal natif requis" >&2; exit 4; }
    ;;
  unavailable)
    [ -n "$native_evidence" ] || { echo "GOAL: preuve d'indisponibilité de l'API native requise" >&2; exit 4; }
    ;;
  *)
    echo "GOAL: NATIVE_GOAL_STATUS doit valoir active ou unavailable avant start-goal.sh" >&2
    exit 4
    ;;
esac

export GOAL_OBJECTIVE="$1" GOAL_VERIFICATION="$2" GOAL_CONSTRAINTS="$3" GOAL_BLOCKED="$4"
export GOAL_CARD="${5:-none}" GOAL_BRANCH="${6:-none}" GOAL_DELEGATION="${7:-none}"
export GOAL_AGENTS_CREATED="${8:-${GOAL_AGENTS_CREATED:-}}" GOAL_AGENT_ASSIGNMENTS="${9:-${GOAL_AGENT_ASSIGNMENTS:-}}"
if [ "$GOAL_DELEGATION" = "none" ]; then
  echo "GOAL: travail sans analyse de délégation; fournir les agents et affectations, ou 'séquentiel justifié' avec sa raison" >&2
  exit 3
fi
if [ "$GOAL_DELEGATION" != "none" ] && [ "$GOAL_DELEGATION" != "séquentiel justifié" ] && { [ -z "$GOAL_AGENTS_CREATED" ] || [ -z "$GOAL_AGENT_ASSIGNMENTS" ]; }; then
  echo "GOAL: délégation annoncée sans agents créés et affectations explicites; création obligatoire avant le démarrage" >&2
  exit 3
fi
if [[ "$GOAL_DELEGATION" =~ (parall|indépend|multi[-_]t[aâ]che|plusieurs) ]]; then
  agent_count=$(( $(tr -cd ',' <<< "$GOAL_AGENTS_CREATED" | wc -c) + 1 ))
  assignment_count=$(( $(tr -cd ',' <<< "$GOAL_AGENT_ASSIGNMENTS" | wc -c) + 1 ))
  if [ "$agent_count" -lt 2 ] || [ "$assignment_count" -lt 2 ]; then
    echo "GOAL: lots parallèles détectés sans au moins deux agents et affectations distinctes" >&2
    exit 3
  fi
fi
export GOAL_STARTED_AT="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
export GOAL_SESSION_ID="goal-${GOAL_STARTED_AT//:/}"

python3 - "$state" <<'PY'
import os
import pathlib
import re
import sys

path = pathlib.Path(sys.argv[1])
text = path.read_text()
values = {
    "Dernière mise à jour": os.environ["GOAL_STARTED_AT"],
    "execution_session": os.environ["GOAL_SESSION_ID"],
    "execution_status": "running",
    "active_card": os.environ["GOAL_CARD"],
    "current_action": "Goal initialisé, lecture de l état et du work item",
    "next_action": "Relire RUNTIME-STATE.md et exécuter la première action du Goal",
    "last_observable_evidence": "Goal initialisé par start-goal.sh à " + os.environ["GOAL_STARTED_AT"],
    "goal_status": "active",
    "goal_objective": os.environ["GOAL_OBJECTIVE"],
    "goal_verification": os.environ["GOAL_VERIFICATION"],
    "goal_constraints": os.environ["GOAL_CONSTRAINTS"],
    "goal_budget": "within-limit",
    "goal_blocked_condition": os.environ["GOAL_BLOCKED"],
    "goal_session_id": os.environ["GOAL_SESSION_ID"],
    "native_goal_status": os.environ["NATIVE_GOAL_STATUS"],
    "native_goal_id": os.environ.get("NATIVE_GOAL_ID", "none"),
    "native_goal_evidence": os.environ["NATIVE_GOAL_EVIDENCE"],
    "goal_delivery_status": "pending",
    "goal_delegation_plan": os.environ["GOAL_DELEGATION"],
    "goal_agents_created": os.environ.get("GOAL_AGENTS_CREATED") or ("none" if os.environ["GOAL_DELEGATION"] in ("none", "séquentiel justifié") else "missing"),
    "goal_agent_assignments": os.environ.get("GOAL_AGENT_ASSIGNMENTS") or ("none" if os.environ["GOAL_DELEGATION"] in ("none", "séquentiel justifié") else "missing"),
    "integration_branch": os.environ["GOAL_BRANCH"],
    "pushed_integration_commit": "none",
    "integration_remote_evidence": "none",
    "pull_request_status": "not-required",
    "last_turn_status": "verified",
    "session_status": "active",
}
for key, value in values.items():
    pattern = r"(?m)^- Dernière mise à jour\s*:.*$" if key == "Dernière mise à jour" else rf"(?m)^- {re.escape(key)}\s*:.*$"
    replacement = f"- {key}: {value}"
    text, count = re.subn(pattern, replacement, text, count=1)
    if count != 1:
        raise SystemExit(f"GOAL: champ absent dans RUNTIME-STATE.md: {key}")
path.write_text(text)
PY

printf '%s | event=goal-started | session=%s | card=%s | delegation=%s | objective=%s\n' \
  "$GOAL_STARTED_AT" "$GOAL_SESSION_ID" "$GOAL_CARD" "$GOAL_DELEGATION" "$GOAL_OBJECTIVE" >> "$events"
echo "Goal actif: $GOAL_SESSION_ID"
