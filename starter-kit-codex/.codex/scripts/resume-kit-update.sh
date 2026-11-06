#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
state="$config/RUNTIME-STATE.md"
backup="$config/.kit-update-resume-state"
[ -f "$backup" ] || { echo "Aucun état de mise à jour à reprendre." >&2; exit 1; }
cp "$backup" "$state"
rm -f "$backup"
perl -0pi -e 's/execution_status: paused-kit-update/execution_status: running/; s/session_status: paused-kit-update/session_status: active/' "$state"
echo "KIT-UPDATE: état restauré; reprendre next_action avant toute clôture."
