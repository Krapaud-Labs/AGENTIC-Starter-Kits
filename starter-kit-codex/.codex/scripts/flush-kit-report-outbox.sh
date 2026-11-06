#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
outbox="$root/.kit-reports/outbox"
archive="$root/.kit-reports/sent"
repository="${KIT_REPORT_REPOSITORY:-Krapaud-Labs/AGENTIC-Starter-Kits}"
[ -d "$outbox" ] || exit 0
command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1 || { echo 'KIT-REPORTS: queued, gh non authentifié; retry=session-start' >&2; exit 0; }
mkdir -p "$archive"
for file in "$outbox"/*.md; do
  [ -f "$file" ] || continue
  fingerprint="$(sed -n 's/^KIT_REPORT_FINGERPRINT:\([a-f0-9]*\)$/\1/p' "$file" | head -1)"
  [ -n "$fingerprint" ] || { echo "KIT-REPORTS: rapport ignoré sans empreinte $file" >&2; continue; }
  existing="$(gh issue list --repo "$repository" --state all --label kit-report --limit 100 --json body 2>/dev/null | jq --arg fp "KIT_REPORT_FINGERPRINT:$fingerprint" '[.[] | select((.body // "") | contains($fp))] | length' || echo 0)"
  if [ "$existing" -gt 0 ]; then mv "$file" "$archive/"; continue; fi
  title="$(sed -n 's/^Gravité$/x/; /\[KIT-REPORT\]/p' "$file" | head -1)"
  title="[KIT-REPORT] $(basename "$file" .md)"
  url="$(gh issue create --repo "$repository" --title "$title" --body-file "$file" --label kit-report 2>/dev/null || true)"
  if [ -n "$url" ]; then mv "$file" "$archive/"; printf '%s | status=sent | fingerprint=%s | url=%s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$fingerprint" "$url" >> "$root/.kit-reports/history.log"; echo "KIT-REPORTS: envoyé $url"; fi
done
