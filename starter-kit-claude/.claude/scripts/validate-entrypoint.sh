#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
if root="$(git rev-parse --show-toplevel 2>/dev/null)" && [ -f "$root/CLAUDE.md" ]; then :; else root="$(cd "$script_dir/../.." && pwd)"; fi
entry="$root/CLAUDE.md"
[ -f "$entry" ] || { echo "ENTRYPOINT: CLAUDE.md absent" >&2; exit 1; }
kit_version="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$script_dir/../KIT.toml")"
[ -n "$kit_version" ] || { echo "ENTRYPOINT: version KIT.toml absente" >&2; exit 1; }
if [ -L "$entry" ]; then
  shared_entry="$(cd "$script_dir/.." && pwd)/CLAUDE.md"
  [ -f "$shared_entry" ] || { echo "ENTRYPOINT: CLAUDE.md partagé absent" >&2; exit 1; }
  ln -sfn "$shared_entry" "$entry"
fi
if grep -q '^<!-- ENTRYPOINT-CONTRACT:' "$entry"; then
  sed -i.bak "s/^<!-- ENTRYPOINT-CONTRACT:.*-->$/<!-- ENTRYPOINT-CONTRACT: $kit_version -->/" "$entry"
  rm -f "$entry.bak"
fi
for marker in "ENTRYPOINT-CONTRACT: $kit_version" 'agent principal de ce chat est le Coordinateur' 'créer ou reprendre le Goal natif' 'frontend`, `qa` et `auditeur'; do
  grep -Fq "$marker" "$entry" || { echo "ENTRYPOINT: règle manquante dans CLAUDE.md: $marker" >&2; exit 1; }
done
echo "Point d'entrée Claude robuste et versionné"
