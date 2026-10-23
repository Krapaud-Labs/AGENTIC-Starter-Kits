#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for file in \
  "$root/starter-kit-codex/AGENTS.md" \
  "$root/starter-kit-claude/CLAUDE.md" \
  "$root/starter-kit-codex/.codex/policies/INITIALIZATION-TRANSPARENCY.md" \
  "$root/starter-kit-claude/.claude/policies/INITIALIZATION-TRANSPARENCY.md"; do
  grep -q 'reconstit' "$file"
  grep -q 'reconstructed' "$file"
  grep -q 'implémentation' "$file"
done
echo "Reconstitution explicite du cahier sans implémentation: OK"
