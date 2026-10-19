#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if root="$(git rev-parse --show-toplevel 2>/dev/null)" && [ -f "$root/.claude/RUNTIME-STATE.md" ]; then state="$root/.claude/RUNTIME-STATE.md"; else state="$(cd "$script_dir/.." && pwd)/RUNTIME-STATE.md"; fi
[ "$#" -ge 2 ] || { echo "Usage: $0 REQUEST_ID ANSWER" >&2; exit 2; }
request_id="$1"; answer="$2"
value() { sed -n "s/^-\{0,1\}[[:space:]]*$1:[[:space:]]*//p" "$state" | head -n 1; }
[ -f "$state" ] || { echo "INPUT: RUNTIME-STATE.md absent" >&2; exit 1; }
[ "$(value pending_request_id)" = "$request_id" ] || { echo "INPUT: demande différente ou déjà résolue" >&2; exit 3; }
[ "$(value required_action_status)" = "pending" ] || { echo "INPUT: aucune réponse en attente" >&2; exit 3; }
safe_answer="$(printf '%s' "$answer" | tr '\n' ' ' | sed 's/[|]/-/g')"
now="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
perl -0pi -e "s/^- execution_status:.*$/- execution_status: running/m; s/^- session_status:.*$/- session_status: active/m; s/^- pending_request_id:.*$/- pending_request_id: resolved/m; s/^- pending_turn_id:.*$/- pending_turn_id: resolved/m; s/^- required_action_status:.*$/- required_action_status: resolved/m; s/^- current_action:.*$/- current_action: user-response-$request_id/m; s/^- next_action:.*$/- next_action: process-user-response-$request_id/m; s/^- last_observable_evidence:.*$/- last_observable_evidence: $now | user-response-$request_id-$safe_answer/m; s/^- goal_status: complete$/- goal_status: active/m; s/^- goal_delivery_status: verified$/- goal_delivery_status: pending/m; s/^- user_response:.*$/- user_response: $safe_answer/m" "$state"
if ! grep -q '^\- user_response:' "$state"; then printf '\n- user_response: %s\n' "$safe_answer" >> "$state"; fi
printf 'INPUT RESOLVED [%s] %s\n' "$request_id" "$safe_answer"
