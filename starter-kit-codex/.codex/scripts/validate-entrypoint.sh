#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if root="$(git rev-parse --show-toplevel 2>/dev/null)" && [ -f "$root/AGENTS.md" ]; then :; else root="$(cd "$script_dir/../.." && pwd)"; fi
entry="$root/AGENTS.md"
[ -f "$entry" ] || { echo "ENTRYPOINT: AGENTS.md absent" >&2; exit 1; }
entry_is_link=false
if [ -L "$entry" ]; then entry_is_link=true; fi
kit_version="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$script_dir/../KIT.toml")"
[ -n "$kit_version" ] || { echo "ENTRYPOINT: version KIT.toml absente" >&2; exit 1; }
if ! grep -Fq "ENTRYPOINT-CONTRACT: $kit_version" "$entry"; then
  echo "ENTRYPOINT: version attendue $kit_version absente; mettre à jour explicitement le point d'entrée" >&2
  exit 1
fi
for marker in 'agent principal de ce chat est le Coordinateur' 'créer ou reprendre le Goal natif' 'frontend`, `qa` et `auditeur'; do
  grep -Fq "$marker" "$entry" || { echo "ENTRYPOINT: règle manquante dans AGENTS.md: $marker" >&2; exit 1; }
done
echo "Point d'entrée Codex robuste et versionné"
