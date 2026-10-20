#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
failures=0
for kit in codex claude; do
  if [ "$kit" = codex ]; then hidden=.codex; entry=AGENTS.md; else hidden=.claude; entry=CLAUDE.md; fi
  base="$root/starter-kit-$kit"
  policy="$base/$hidden/policies/CONTEXT-EFFICIENCY-POLICY.md"
  [ -f "$policy" ] || { echo "CONTEXTE: policy absente pour $kit" >&2; failures=$((failures+1)); continue; }
  [ -s "$base/$entry" ] || { echo "CONTEXTE: entrée absente pour $kit" >&2; failures=$((failures+1)); }
  grep -q 'empreinte' "$policy" || { echo "CONTEXTE: cache par empreinte absent pour $kit" >&2; failures=$((failures+1)); }
  grep -q 'CHANGELOG.md' "$policy" || { echo "CONTEXTE: règle de chargement ciblé absente pour $kit" >&2; failures=$((failures+1)); }
done
printf 'CONTEXTE: %s octets d instructions publiques\n' "$(wc -c < "$root/README.md" | tr -d ' ')"
if [ "$failures" -ne 0 ]; then exit 1; fi
echo 'Audit efficacité contexte OK'
