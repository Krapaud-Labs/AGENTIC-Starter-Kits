#!/usr/bin/env bash
set -euo pipefail
state="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)/RUNTIME-STATE.md"
value() { sed -n "s/^-[[:space:]]*$1:[[:space:]]*//p" "$state" | head -n 1; }
count="$(value blocker_repeat_count)"; action="$(value next_action)"; previous="$(value previous_blocked_action)"
if [[ "$count" =~ ^[0-9]+$ ]] && [ "$count" -ge 2 ] && [ -n "$action" ] && [ "$action" = "$previous" ]; then
  echo "BOUCLE BLOQUANTE: même blocage répété; changer d'approche et exécuter une alternative avant toute conclusion." >&2
  exit 1
fi
echo "Garde anti-boucle OK"
