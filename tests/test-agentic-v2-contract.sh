#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for file in "$root/docs/v2/ARCHITECTURE.md" "$root/docs/v2/MIGRATION-1X-TO-2X.md" "$root/docs/v2/RELEASE-GATES.md"; do
  test -s "$file" || { echo "V2-CONTRACT: document manquant $file" >&2; exit 1; }
done
for kit_root in "$root/starter-kit-codex/.codex" "$root/starter-kit-claude/.claude"; do
  test -s "$kit_root/runtime_v2/core.py" || { echo "V2-CONTRACT: runtime absent $kit_root" >&2; exit 1; }
  test -s "$kit_root/scripts/agentic_orchestration.py" || { echo "V2-CONTRACT: orchestration absente $kit_root" >&2; exit 1; }
  test -s "$kit_root/scripts/migrate_agentic_card.py" || { echo "V2-CONTRACT: migration absente $kit_root" >&2; exit 1; }
done
for required in \
  'installation shared' \
  'état runtime canonique' \
  'audit uniquement sur demande ou carte dédiée' \
  'migration obligatoire' \
  'rollback' \
  'PR unique' \
  'dev'; do
  rg -Fq "$required" "$root/docs/v2" || { echo "V2-CONTRACT: exigence absente $required" >&2; exit 1; }
done
echo 'V2-CONTRACT: OK'
