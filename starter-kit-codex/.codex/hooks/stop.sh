#!/usr/bin/env bash
set -euo pipefail
event="$(cat)"
active="$(printf '%s' "$event" | jq -r '.stop_hook_active // false' 2>/dev/null || echo false)"
[ "$active" = "true" ] && exit 0
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
if ! bash "$root/.codex/scripts/guard-before-response.sh" >/dev/null 2>&1; then
  printf '{"decision":"block","reason":"La clôture est refusée : le Goal, la prochaine action, les preuves ou la livraison ne sont pas vérifiés. Reprendre automatiquement la prochaine action autonome."}\n'
fi
