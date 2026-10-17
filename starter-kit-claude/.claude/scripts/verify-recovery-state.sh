#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
state="$config/RUNTIME-STATE.md"

value() { sed -n "s/^-[[:space:]]*$1:[[:space:]]*//p; s/^$1:[[:space:]]*//p" "$state" 2>/dev/null | head -n 1; }
[ -f "$state" ] || { echo "RECOVERY CHECK: état runtime absent" >&2; exit 1; }
status="$(value execution_status)"
condition="$(value goal_blocked_condition)"
native_status="$(value native_goal_status)"

if [ "$status" = "blocked" ] && [ "$native_status" = "active" ]; then
  echo "RECOVERY REQUIRED: Goal natif actif avec runtime bloqué; réévaluer la cause, changer d'approche et exécuter une action avant toute reprise." >&2
  exit 1
fi
active=""
while IFS= read -r brief; do
  if grep -Fq '| Statut | in-progress |' "$brief"; then active="$(dirname "$brief")"; break; fi
done < <(find "$config/work-items" -mindepth 2 -maxdepth 2 -type f -name brief.md 2>/dev/null | sort)

if [ -n "$active" ] && [ -f "$active/obligations.tsv" ]; then
  open_recovery="$(awk -F '\t' 'NR > 1 && ($1 == "audit-gate" || $1 == "delivery-gate") && ($4 == "pending" || $4 == "running" || $4 == "needs-review" || $4 == "blocked") { print $1 "=" $4 }' "$active/obligations.tsv")"
  if [ -n "$open_recovery" ] && [ "$status" = "blocked" ]; then
    case "$condition" in
      *"externe inaccessible"*|*"décision humaine indispensable"*) ;;
      *)
        echo "RECOVERY REQUIRED: $open_recovery reste(nt) ouverte(s); exécuter next_action et reprendre l'audit ou la livraison avant blocked." >&2
        exit 1
        ;;
    esac
  fi
fi

echo "Recovery state OK: $status"
