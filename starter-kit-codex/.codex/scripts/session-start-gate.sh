#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git rev-parse --show-toplevel 2>/dev/null || cd "$config/.." && pwd)"
mode="$(sed -n 's/^kit_mode = "\([^"]*\)"/\1/p' "$root/.workspace.toml" 2>/dev/null || echo native)"
bash "$script_dir/ensure-tools.sh" --bootstrap >/dev/null
status=0
bash "$script_dir/check-kit-update.sh" >/dev/null 2>"$config/.kit-update-error" || status=$?
if [ "$status" -ne 0 ]; then
  if [ "$status" -eq 3 ] && [ -x "$script_dir/sync-workspace-kit.sh" ]; then
    bash "$script_dir/sync-workspace-kit.sh"
    status=0
  elif [ "$status" -eq 2 ]; then
    echo "KIT-SESSION: source distante indisponible; utilisation contrôlée du kit local" >&2
    status=0
  else
    echo "KIT-SESSION: mise à jour requise ou vérification distante impossible" >&2
    exit 1
  fi
fi
bash "$script_dir/validate-agentic-contract.sh" >/dev/null
printf 'kit_version=%s\nvalidated_at=%s\nmode=%s\n' "$(sed -n 's/^kit_version = "\([^"]*\)"/\1/p' "$config/KIT.toml")" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$mode" > "$config/.session-kit-validated"
rm -f "$config/.kit-update-error"
echo "KIT-SESSION: porte de démarrage validée"
