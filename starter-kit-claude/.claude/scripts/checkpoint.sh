#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || (cd "$config/.." && pwd))"
state="$config/RUNTIME-STATE.md"
events="$config/runtime-events.log"
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <étape> <statut> <message>"
  exit 2
fi
stage="$1"
status="$2"
shift 2
message="$*"
case "$stage" in intake|questionnaire|onboarding|conception|planning|implementation|validation|audit|delivery|maintenance|blocked) ;; *) echo "Étape invalide: $stage"; exit 2 ;; esac
case "$status" in started|completed|failed|blocked|waiting|resumed) ;; *) echo "Statut invalide: $status"; exit 2 ;; esac
now="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
printf '%s | stage=%s | status=%s | message=%s\n' "$now" "$stage" "$status" "$message" >> "$events"
[ -f "$state" ] || { echo "ECHEC CHECKPOINT: RUNTIME-STATE.md absent" >&2; exit 1; }
runtime_status=running
case "$status" in completed) runtime_status=complete;; blocked) runtime_status=blocked;; waiting) runtime_status=waiting-ci;; failed) runtime_status=needs-review;; esac
perl -0pi -e "s/- Dernière mise à jour : .*\n/- Dernière mise à jour : $now\n/; s/- Étape : .*\n/- Étape : $stage\n/; s/- Dernière action réalisée : .*\n/- Dernière action réalisée : $message\n/; s/^- execution_status:.*\$/- execution_status: $runtime_status/m; s/^- current_action:.*\$/- current_action: $message/m; s/^- last_observable_evidence:.*\$/- last_observable_evidence: $now | $message/m" "$state"
echo "Checkpoint enregistré: $stage/$status"
