#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
state="$config/RUNTIME-STATE.md"
backup="$config/.kit-update-resume-state"
[[ -f "$state" ]] || printf '%s\n' '# Runtime state' 'execution_status: running' 'session_status: active' > "$state"
cp "$state" "$backup"
perl -0pi -e 's/execution_status: [^\n]*/execution_status: paused-kit-update/; s/session_status: [^\n]*/session_status: paused-kit-update/' "$state"
echo "KIT-UPDATE: travail suspendu et état sauvegardé dans $backup"
