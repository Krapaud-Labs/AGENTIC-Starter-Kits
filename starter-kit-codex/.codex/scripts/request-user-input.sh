#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if root="$(git rev-parse --show-toplevel 2>/dev/null)" && [ -f "$root/.codex/RUNTIME-STATE.md" ]; then state="$root/.codex/RUNTIME-STATE.md"; else state="$(cd "$script_dir/.." && pwd)/RUNTIME-STATE.md"; fi
[ "$#" -ge 5 ] || { echo "Usage: $0 <id> <question> <choice-id> <choice-label> ..." >&2; exit 2; }
request_id="$1"; question="$2"; shift 2
[ $(( $# % 2 )) -eq 0 ] || { echo "Chaque choix doit avoir un identifiant et un libellé." >&2; exit 2; }
if [ ! -f "$state" ]; then
  printf '%s\n' '# État d’exécution agentique' '' '## Identité' '' '- execution_status: running' '- session_status: active' '- goal_status: active' '- pending_request_id: none' '- pending_turn_id: none' '- required_action_status: none' '- current_action: bootstrap-runtime-state' '- next_action: resume-after-user-response' '- last_observable_evidence: runtime-state-created-by-interactive-request' > "$state"
fi
now="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
perl -0pi -e "s/^- execution_status:.*\$/- execution_status: waiting-for-user/m; s/^- session_status:.*\$/- session_status: waiting-for-user/m; s/^- pending_request_id:.*\$/- pending_request_id: $request_id/m; s/^- pending_turn_id:.*\$/- pending_turn_id: user-response-required/m; s/^- required_action_status:.*\$/- required_action_status: pending/m; s/^- current_action:.*\$/- current_action: waiting-for-user/m; s/^- next_action:.*\$/- next_action: resume-after-user-response/m; s/^- last_observable_evidence:.*\$/- last_observable_evidence: $now | questionnaire-emitted-$request_id/m" "$state"
printf 'WAITING-FOR-USER [%s]\n%s\n' "$request_id" "$question"
number=1
while [ "$#" -gt 0 ]; do printf '%s) %s [%s]\n' "$number" "$2" "$1"; shift 2; number=$((number + 1)); done
printf 'Réponds avec le numéro ou l identifiant. Aucune reprise automatique avant ta réponse.\n'
