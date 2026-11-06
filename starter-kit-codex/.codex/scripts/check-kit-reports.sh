#!/usr/bin/env bash
set -euo pipefail
repository="${KIT_REPORT_REPOSITORY:-Krapaud-Labs/AGENTIC-Starter-Kits}"
command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1 || { echo 'KIT-REPORTS: gh indisponible ou non authentifié'; exit 0; }
history_file="${KIT_REPORT_HISTORY_FILE:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)/docs/audit/kit-report-history.jsonl}"
history='[]'; [ -f "$history_file" ] && history="$(jq -s '.' "$history_file" 2>/dev/null || echo '[]')"
json="$(gh issue list --repo "$repository" --state all --label kit-report --limit 1000 --json number,title,url,state,body 2>/dev/null)" || { echo 'KIT-REPORTS: lecture distante impossible'; exit 3; }
printf '%s' "$json" | jq --argjson history "$history" -r '
  def fp: ((.body // "") | (try capture("KIT_REPORT_FINGERPRINT:(?<id>[a-f0-9]{64})").id catch ""));
  .[] | select(.state == "OPEN") | . as $issue | ($issue|fp) as $id |
  ([ $history[] | select(.fingerprint == $id) | .status ] | last) as $status |
  select($status != "resolved" and $status != "duplicate") |
  "#\(.number) \(.title) | \(.url)"'
