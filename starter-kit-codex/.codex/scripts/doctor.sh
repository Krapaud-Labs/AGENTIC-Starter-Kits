#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
if root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  :
else
  root="$(cd "$config/.." && pwd)"
fi
manifest="$root/.workspace.toml"
kit_file="$config/KIT.toml"
fail=0
hidden=".codex"
entry="AGENTS.md"
report() { printf '%-24s %s\n' "$1" "$2"; }
version="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$kit_file" 2>/dev/null || true)"
report 'Kit local' "${version:-absent}"
if [ -f "$manifest" ]; then
  installed="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$manifest")"
  source="$(sed -n 's/^source = "\(.*\)"/\1/p' "$manifest")"
  mode="$(sed -n 's/^kit_mode = \"\(.*\)\"/\1/p' \"$manifest\")"
  report 'Mode' "${mode:-external}"
  report 'Manifeste' "${installed:-invalide}"
  report 'Source' "${source:-absente}"
else
  report 'Mode' 'native'
fi
[ -f "$config/PROJECT-BRIEF.md" ] && report 'Cahier' 'présent' || { report 'Cahier' 'absent'; fail=1; }
[ -f "$config/RUNTIME-STATE.md" ] && report 'État runtime' 'présent' || report 'État runtime' 'absent'
[ -f "$root/$entry" ] && report 'Point d entrée' 'présent' || { report 'Point d entrée' 'absent'; fail=1; }
if [ -f "$root/.workspace.toml" ]; then
  workflow="$root/.github/workflows/update-workspace-kit.yml"
  [ -f "$workflow" ] && report "Workflow ${mode:-external}" 'présent' || { report "Workflow ${mode:-external}" 'absent'; fail=1; }
  if [ -d "$config/$hidden" ]; then report 'Doublon imbriqué' 'absent'; else report 'Doublon imbriqué' 'absent'; fi
fi
if git -C "$root" ls-files --error-unmatch "$hidden" "$entry" >/dev/null 2>&1; then
  report 'Fichiers external suivis' 'ERREUR'; fail=1
else
  report 'Fichiers external suivis' 'absents'
fi
if [ "$fail" -eq 0 ]; then echo 'Diagnostic OK'; else echo 'Diagnostic incomplet'; fi
exit "$fail"
