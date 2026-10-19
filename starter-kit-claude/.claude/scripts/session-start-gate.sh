#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
if root="$(git rev-parse --show-toplevel 2>/dev/null)" && [ -f "$root/CLAUDE.md" ]; then
  :
else
  root="$(cd "$config/.." && pwd)"
fi
project_config="$root/.claude"
entry="$root/CLAUDE.md"
kit_version="$(sed -n 's/^kit_version = "\([^"]*\)"/\1/p' "$config/KIT.toml")"
if [ -f "$entry" ] && grep -q '^<!-- ENTRYPOINT-CONTRACT:' "$entry"; then
  sed -i.bak "s/^<!-- ENTRYPOINT-CONTRACT:.*-->$/<!-- ENTRYPOINT-CONTRACT: $kit_version -->/" "$entry"
  rm -f "$entry.bak"
fi
mode="$(sed -n 's/^kit_mode = "\([^"]*\)"/\1/p' "$root/.workspace.toml" 2>/dev/null || echo native)"
bash "$script_dir/ensure-tools.sh" --bootstrap >/dev/null
status=0
bash "$script_dir/check-kit-update.sh" >/dev/null 2>"$project_config/.kit-update-error" || status=$?
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
rm -f "$project_config/.kit-update-error"
printf 'kit_version=%s\nvalidated_at=%s\nmode=%s\n' "$kit_version" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$mode" > "$project_config/.session-kit-validated"
echo "KIT-SESSION: porte de démarrage validée"
