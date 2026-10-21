#!/usr/bin/env bash
set -euo pipefail
role="${1:-}"
agent_id="${2:-}"
report="${3:-}"
[ -n "$role" ] && [ -n "$agent_id" ] && [ -n "$report" ] || { echo "RAPPORT: rôle, identifiant et chemin requis" >&2; exit 1; }
if [ "$report" = "/dev/stdin" ]; then report_copy="$(mktemp)"; cat > "$report_copy"; report="$report_copy"; trap 'rm -f "$report_copy"' EXIT; fi
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
archive="$root/.codex/reports/agents/$agent_id.md"
if [ ! -s "$report" ] && [ -s "$archive" ]; then report="$archive"; fi
[ -s "$report" ] || { echo "RAPPORT: livrable absent ou vide pour $role@$agent_id" >&2; exit 1; }
grep -Eq '^agent_role:[[:space:]]*' "$report" || { echo "RAPPORT: agent_role manquant" >&2; exit 1; }
grep -Eq '^agent_id:[[:space:]]*' "$report" || { echo "RAPPORT: agent_id manquant" >&2; exit 1; }
grep -Eq '^status:[[:space:]]*(accepted|rework|blocked)$' "$report" || { echo "RAPPORT: status accepted, rework ou blocked requis" >&2; exit 1; }
grep -Eq '^scope:[[:space:]]*[^[:space:]].*' "$report" || { echo "RAPPORT: scope manquant" >&2; exit 1; }
grep -Eq '^evidence:[[:space:]]*[^[:space:]].*' "$report" || { echo "RAPPORT: evidence manquante" >&2; exit 1; }
grep -Eq '^next_action:[[:space:]]*[^[:space:]].*' "$report" || { echo "RAPPORT: next_action manquante" >&2; exit 1; }
actual_role="$(sed -n 's/^agent_role:[[:space:]]*//p' "$report" | head -1)"
actual_id="$(sed -n 's/^agent_id:[[:space:]]*//p' "$report" | head -1)"
[ "$actual_role" = "$role" ] || { echo "RAPPORT: rôle incohérent ($actual_role != $role)" >&2; exit 1; }
[ "$actual_id" = "$agent_id" ] || { echo "RAPPORT: identifiant incohérent ($actual_id != $agent_id)" >&2; exit 1; }
mkdir -p "$(dirname "$archive")"
[ "$report" = "$archive" ] || cp "$report" "$archive"
pending="$(dirname "$archive")/pending.tsv"
if [ -f "$pending" ]; then
  tmp="$pending.tmp.$$"
  awk -F '\t' -v id="$agent_id" '$1 != id' "$pending" > "$tmp"
  mv "$tmp" "$pending"
fi
echo "Rapport spécialiste vérifié: $role@$agent_id"
