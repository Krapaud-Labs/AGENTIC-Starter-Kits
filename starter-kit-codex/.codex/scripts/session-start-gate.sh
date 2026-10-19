#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
if root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  :
else
  root="$(cd "$config/.." && pwd)"
fi
project_config="$root/.codex"
mode="$(sed -n 's/^kit_mode = "\([^"]*\)"/\1/p' "$root/.workspace.toml" 2>/dev/null || echo native)"
tool_status=0
bash "$script_dir/ensure-tools.sh" --bootstrap >/dev/null 2>"$project_config/.tool-bootstrap-error" || tool_status=$?
if [ "$tool_status" -eq 4 ]; then echo "KIT-SESSION: waiting-for-user" >&2; exit 4; elif [ "$tool_status" -ne 0 ]; then echo "KIT-SESSION: bootstrap des outils impossible" >&2; exit "$tool_status"; fi
rm -f "$project_config/.tool-bootstrap-error"
status=0
bash "$script_dir/check-kit-update.sh" >/dev/null 2>"$project_config/.kit-update-error" || status=$?
if [ "$status" -ne 0 ]; then
  if [ "$status" -eq 3 ] && [ -x "$script_dir/sync-workspace-kit.sh" ]; then bash "$script_dir/sync-workspace-kit.sh"; status=0
  elif [ "$status" -eq 2 ]; then echo "KIT-SESSION: source distante indisponible; utilisation contrôlée du kit local" >&2; status=0
  else echo "KIT-SESSION: mise à jour requise ou vérification distante impossible" >&2; exit 1; fi
fi
bash "$script_dir/validate-agentic-contract.sh" >/dev/null
printf 'kit_version=%s\nvalidated_at=%s\nmode=%s\n' "$(sed -n 's/^kit_version = "\([^"]*\)"/\1/p' "$config/KIT.toml")" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$mode" > "$project_config/.session-kit-validated"
rm -f "$project_config/.kit-update-error"
echo "KIT-SESSION: porte de démarrage validée"
