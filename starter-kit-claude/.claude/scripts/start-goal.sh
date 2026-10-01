#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 4 ] || [ "$#" -gt 7 ]; then
  echo "Usage: $0 OBJECTIF VERIFICATION CONTRAINTES CONDITION_BLOCAGE [CARTE] [BRANCHE] [DELEGATION]" >&2
  exit 2
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
state="$config/RUNTIME-STATE.md"
events="$config/runtime-events.log"
[ -f "$state" ] || { echo "GOAL: RUNTIME-STATE.md absent" >&2; exit 1; }

export GOAL_OBJECTIVE="$1" GOAL_VERIFICATION="$2" GOAL_CONSTRAINTS="$3" GOAL_BLOCKED="$4"
export GOAL_CARD="${5:-none}" GOAL_BRANCH="${6:-none}" GOAL_DELEGATION="${7:-none}"
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
    "goal_delivery_status": "pending",
    "goal_delegation_plan": os.environ["GOAL_DELEGATION"],
    "goal_agents_created": "pending-assessment",
    "goal_agent_assignments": "pending-assessment",
    "integration_branch": os.environ["GOAL_BRANCH"],
    "pushed_integration_commit": "none",
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
