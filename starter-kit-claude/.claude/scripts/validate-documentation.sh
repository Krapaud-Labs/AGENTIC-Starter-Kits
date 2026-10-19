#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
docs="$root/docs"
[ -d "$docs" ] || { echo "Documentation projet non applicable dans le kit: $docs"; exit 0; }
errors=0
while IFS= read -r -d '' file; do
  grep -q '^---$' "$file" || { echo "Métadonnées absentes: $file" >&2; errors=$((errors + 1)); }
  grep -q 'last_updated:' "$file" || { echo "Date absente: $file" >&2; errors=$((errors + 1)); }
  grep -q 'A_COMPLETER' "$file" && { echo "Marqueur incomplet: $file" >&2; errors=$((errors + 1)); }
done < <(find "$docs" -type f -name '*.md' -print0)
[ "$errors" -eq 0 ] || { echo "Audit documentaire échoué: $errors problème(s)." >&2; exit 1; }
echo "Audit documentaire validé."
