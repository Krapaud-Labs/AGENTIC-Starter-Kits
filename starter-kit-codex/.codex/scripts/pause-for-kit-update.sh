#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || cd "$config/.." && pwd)"
state="$config/RUNTIME-STATE.md"
if [ ! -f "$state" ]; then
  cat >"$state" <<'EOF'
# Runtime state

execution_status: running
session_status: active
current_action: bootstrap-runtime-state
next_action: continue-kit-update
open_checklist_items: 0
last_observable_evidence: runtime-state-created-by-kit-bootstrap
EOF
  echo "KIT-UPDATE: RUNTIME-STATE.md initialisé automatiquement."
fi

backup="$config/.kit-update-resume-state"
cp "$state" "$backup"
perl -0pi -e 's/execution_status: [^\n]*/execution_status: paused-kit-update/; s/session_status: [^\n]*/session_status: paused-kit-update/; s/last_observable_evidence: [^\n]*/last_observable_evidence: kit-update-paused/; s/next_action: [^\n]*/next_action: restore-kit-update-state-and-resume/' "$state"

echo "KIT-UPDATE: travail suspendu et état sauvegardé dans $backup"
echo "KIT-UPDATE: appliquer la mise à jour, livrer la PR vers dev, vérifier dev, puis exécuter resume-kit-update.sh"
