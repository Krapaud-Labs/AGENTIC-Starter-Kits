#!/usr/bin/env bash
set -euo pipefail

history_file="${KIT_REPORT_HISTORY_FILE:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)/docs/audit/kit-report-history.jsonl}"
fingerprint=""
status=""
issue=""
note=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --fingerprint) fingerprint="${2:?empreinte manquante}"; shift 2 ;;
    --status) status="${2:?statut manquant}"; shift 2 ;;
    --issue) issue="${2:-}"; shift 2 ;;
    --note) note="${2:-}"; shift 2 ;;
    *) echo "Argument inconnu: $1" >&2; exit 2 ;;
  esac
done
[ -n "$fingerprint" ] || { echo 'Empreinte requise' >&2; exit 2; }
case "$status" in bloquant|normal|resolved|duplicate) ;; *) echo "Statut invalide: $status" >&2; exit 2 ;; esac
mkdir -p "$(dirname -- "$history_file")"
safe_note="$(printf '%s' "$note" | sed -E 's#/(Users|home)/[^ ]+#<local-path>#g; s#(token|secret|password|api[_-]?key)[[:space:]]*=[[:space:]]*[^[:space:]]+#\1=<redacted>#gi' | cut -c1-500)"
lock_dir="${history_file}.lock"
while ! mkdir "$lock_dir" 2>/dev/null; do sleep 0.05; done
trap 'rmdir "$lock_dir" 2>/dev/null || true' EXIT
if [ -f "$history_file" ] && jq -e --arg fp "$fingerprint" 'select(.fingerprint == $fp)' "$history_file" >/dev/null 2>&1; then
  echo "KIT-REPORT-HISTORY: $fingerprint déjà enregistré"
  exit 0
fi
line="$(jq -cn --arg fingerprint "$fingerprint" --arg status "$status" --arg issue "$issue" --arg note "$safe_note" --arg updated "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" '{fingerprint:$fingerprint,status:$status,issue:$issue,note:$note,updated_at:$updated}')"
printf '%s\n' "$line" >> "$history_file"
echo "KIT-REPORT-HISTORY: $fingerprint => $status"
