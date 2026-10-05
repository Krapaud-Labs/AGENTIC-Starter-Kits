#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
root="$(cd "$script_dir/../.." && pwd)"
entry="$root/CLAUDE.md"
[ -f "$entry" ] || { echo "ENTRYPOINT: CLAUDE.md absent" >&2; exit 1; }
for marker in 'ENTRYPOINT-CONTRACT: 1.14.11' 'agent principal de ce chat est le Coordinateur' 'créer ou reprendre le Goal natif' 'frontend`, `qa` et `auditeur'; do
  grep -Fq "$marker" "$entry" || { echo "ENTRYPOINT: règle manquante dans CLAUDE.md: $marker" >&2; exit 1; }
done
echo "Point d'entrée Claude robuste et versionné"
