#!/usr/bin/env bash
set -euo pipefail
config="$(cd -- "$(dirname -- "\${BASH_SOURCE[0]}")/.." && pwd)"
state="$config/RUNTIME-STATE.md"
[ -f "$state" ] || exit 1
pending="$(sed -n 's/^- pending_request_id: //p' "$state" | head -1)"
required="$(sed -n 's/^- required_action_status: //p' "$state" | head -1)"
if [ "$pending" = "none" ] && [ "$required" != "pending" ]; then
  bash "$config/scripts/reconcile-runtime.sh" >/dev/null
  bash "$config/scripts/validate-runtime-schema.sh" >/dev/null
  printf '%s\n' 'Correction locale appliquée: état utilisateur résiduel réconcilié.'
  exit 0
fi
exit 4
