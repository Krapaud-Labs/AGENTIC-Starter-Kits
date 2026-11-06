#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
codex="$root/starter-kit-codex/.codex/tool-manifest.tsv"
claude="$root/starter-kit-claude/.claude/tool-manifest.tsv"
for manifest in "$codex" "$claude"; do
  [ -s "$manifest" ] || { echo "REGISTRE: manifeste absent $manifest" >&2; exit 1; }
  awk -F '\t' 'NR > 1 && NF >= 3 { if ($3 == "") exit 1; count[$3]++ } END { for (command in count) if (count[command] > 1) exit 2 }' "$manifest" || {
    echo "REGISTRE: commande vide ou dupliquée dans $manifest" >&2
    exit 1
  }
done
diff -u <(tail -n +2 "$codex" | cut -f1-3) <(tail -n +2 "$claude" | cut -f1-3) >/dev/null || {
  echo 'REGISTRE: les manifestes Codex et Claude divergent' >&2
  exit 1
}
echo 'Registre central des outils: OK'
