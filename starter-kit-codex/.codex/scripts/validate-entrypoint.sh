#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$script_dir/../.." && pwd)"
entry="$root/AGENTS.md"
[ -f "$entry" ] || { echo "ENTRYPOINT: AGENTS.md absent" >&2; exit 1; }
kit_version="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$script_dir/../KIT.toml")"
[ -n "$kit_version" ] || { echo "ENTRYPOINT: version KIT.toml absente" >&2; exit 1; }
for marker in "ENTRYPOINT-CONTRACT: $kit_version" 'agent principal de ce chat est le Coordinateur' 'créer ou reprendre le Goal natif' 'frontend`, `qa` et `auditeur'; do
  grep -Fq "$marker" "$entry" || { echo "ENTRYPOINT: règle manquante dans AGENTS.md: $marker" >&2; exit 1; }
done
echo "Point d'entrée Codex robuste et versionné"
