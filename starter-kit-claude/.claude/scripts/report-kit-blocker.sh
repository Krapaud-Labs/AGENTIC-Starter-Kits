#!/usr/bin/env bash
set -euo pipefail

severity=normal
summary="Blocage du kit"
details=""
repository="${KIT_REPORT_REPOSITORY:-Krapaud-Labs/AGENTIC-Starter-Kits}"
config="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
if root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null)"; then
  :
else
  root="$(cd "$config/.." && pwd)"
fi
outbox="$root/.kit-reports/outbox"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --severity) severity="${2:?gravité manquante}"; shift 2 ;;
    --summary) summary="${2:?résumé manquant}"; shift 2 ;;
    --details) details="${2:?détails manquants}"; shift 2 ;;
    -h|--help) echo 'Usage: report-kit-blocker.sh [--severity normal|bloquant] [--summary TEXT] [--details TEXT]'; exit 0 ;;
    *) echo "Argument inconnu: $1" >&2; exit 2 ;;
  esac
done
case "$severity" in normal|bloquant) ;; *) echo "Gravité invalide: $severity" >&2; exit 2 ;; esac

if correction="$("$config/scripts/auto-remediate-kit-report.sh" 2>/dev/null)"; then
  severity=normal
  summary="Correction automatique du kit appliquée"
  details="$correction"
fi

sanitize() {
  sed -E \
    -e 's#/(Users|home)/[^ ]+#<local-path>#g' \
    -e 's#(gh[pousr]_[A-Za-z0-9_:-]+|github_pat_[A-Za-z0-9_:-]+|sk-[A-Za-z0-9_:-]+|Bearer[[:space:]]+[A-Za-z0-9._:-]+)#<redacted>#g' \
    -e 's#(password|passwd|token|secret|api[_-]?key)[[:space:]]*=[[:space:]]*[^[:space:]]+#\1=<redacted>#gi'
}

safe_summary="$(printf '%s' "$summary" | sanitize | tr '\n' ' ' | cut -c1-180)"
safe_details="$(printf '%s' "$details" | sanitize | cut -c1-12000)"
version="$(sed -n 's/^kit_version = "\([^"]*\)"/\1/p' "$config/KIT.toml" 2>/dev/null || echo unknown)"
fingerprint="$(printf '%s\n%s\n%s' "$severity" "$safe_summary" "$safe_details" | shasum -a 256 | cut -d' ' -f1)"
body="$(printf '%s\n' \
  '## Rapport automatique du kit' \
  '' 'Gravité' "$severity" \
  '' 'Version du kit' "$version" \
  '' "KIT_REPORT_FINGERPRINT:$fingerprint" \
  '' 'Résumé' "$safe_summary" \
  '' 'Preuve anonymisée' "$safe_details" \
  '' 'Ce rapport ne contient volontairement aucun secret, token, chemin personnel ou donnée projet sensible.')"

mkdir -p "$outbox"
queued="$outbox/$fingerprint.md"
printf '%s\n' "$body" > "$queued"

if [ "${KIT_REPORT_DRY_RUN:-0}" = 1 ]; then echo "KIT-REPORT: dry-run $queued"; exit 0; fi
if ! command -v gh >/dev/null 2>&1 || ! gh auth status >/dev/null 2>&1; then
  echo "KIT-REPORT: rapport mis en file hors ligne $queued" >&2; exit 0
fi
if ! existing_json="$(gh issue list --repo "$repository" --state all --label kit-report --limit 1000 --json body,state,labels 2>/dev/null)"; then
  echo "KIT-REPORT: recherche distante impossible, rapport conservé $queued" >&2
  exit 0
fi
existing="$(printf '%s' "$existing_json" | jq --arg fp "KIT_REPORT_FINGERPRINT:$fingerprint" '[.[] | select((.body // "") | contains($fp))] | length')"
if [ "$existing" -gt 0 ]; then echo "KIT-REPORT: doublon ignoré $fingerprint"; exit 0; fi
url="$(gh issue create --repo "$repository" --title "[KIT-REPORT][$severity] $safe_summary" --body "$body" --label kit-report 2>/dev/null || true)"
if [ -n "$url" ]; then rm -f "$queued"; echo "KIT-REPORT: envoyé $url"; else echo "KIT-REPORT: envoi impossible, rapport conservé $queued" >&2; fi
