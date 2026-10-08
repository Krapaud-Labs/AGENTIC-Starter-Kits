#!/usr/bin/env bash
set -euo pipefail
status="${NATIVE_GOAL_STATUS:-}"
case "$status" in
  active) [ -n "${NATIVE_GOAL_ID:-}" ] && [ "$NATIVE_GOAL_ID" != none ] || { echo "GOAL NATIF: actif sans identifiant" >&2; exit 2; }; echo "Goal natif actif: $NATIVE_GOAL_ID" ;;
  paused|blocked) echo "GOAL NATIF NON ACTIF: exécuter /goal resume dans l'interface Codex, puis relancer la reprise." >&2; exit 4 ;;
  unavailable) echo "GOAL NATIF INDISPONIBLE: conserver le suivi local sans le présenter comme natif." >&2; exit 5 ;;
  *) echo "GOAL NATIF INCONNU: vérifier /goal avant toute action." >&2; exit 3 ;;
esac
