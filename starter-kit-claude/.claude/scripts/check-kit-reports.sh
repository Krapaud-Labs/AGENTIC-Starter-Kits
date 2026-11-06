#!/usr/bin/env bash
set -euo pipefail
repository="${KIT_REPORT_REPOSITORY:-Krapaud-Labs/AGENTIC-Starter-Kits}"
command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1 || { echo 'KIT-REPORTS: gh indisponible ou non authentifié'; exit 0; }
json="$(gh issue list --repo "$repository" --state open --label kit-report --limit 100 --json number,title,url 2>/dev/null || echo '[]')"
echo "KIT-REPORTS: rapports ouverts $(printf '%s' "$json" | jq 'length')"
printf '%s' "$json" | jq -r '.[] | "#\(.number) \(.title) | \(.url)"'
