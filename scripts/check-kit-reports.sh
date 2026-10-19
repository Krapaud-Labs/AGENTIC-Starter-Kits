#!/usr/bin/env bash
set -euo pipefail

label="${KIT_REPORT_LABEL:-kit-report}"
repo="${KIT_REPORT_REPOSITORY:-}"
history_file="${KIT_REPORT_HISTORY_FILE:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)/docs/audit/kit-report-history.jsonl}"

command -v gh >/dev/null 2>&1 || {
  echo "KIT-REPORTS: gh indisponible, lecture distante reportée" >&2
  exit 0
}

args=(issue list --state all --label "$label" --limit 100 --json number,title,body,labels,state,createdAt,closedAt,url)
[ -n "$repo" ] && args+=(--repo "$repo")
json="$(gh "${args[@]}" 2>/dev/null || true)"
[ -n "$json" ] || { echo "KIT-REPORTS: aucune issue lisible"; exit 0; }
history='[]'
[ -f "$history_file" ] && history="$(jq -s '.' "$history_file" 2>/dev/null || echo '[]')"

printf '%s\n' "$json" | jq --argjson history "$history" -r '
  def blocking:
    ([.labels[]?.name] | any(. == "priority:critical" or . == "severity:blocking" or . == "bloquant"))
    or ((.title + " " + (.body // "")) | test("(?i)(bloquant|blocker|critical|critique)"));
  def fingerprint: ((.body // "") | (try capture("KIT_REPORT_FINGERPRINT:(?<id>[a-f0-9]+)").id catch ""));
  def history_status:
    ([ $history[] | select(.fingerprint == (fingerprint)) | .status ] | last) // empty;
  if length == 0 then
    "KIT-REPORTS: aucun rapport ouvert"
  else
    "KIT-REPORTS: rapports ouverts " + (length|tostring),
    (sort_by(if blocking then 0 else 1 end, .createdAt)
      | .[]
      | (if (history_status == "resolved") then "RESOLU"
         elif (history_status == "duplicate") then "DOUBLON"
         elif (.state == "CLOSED") then "RESOLU"
         elif blocking then "BLOQUANT" else "NORMAL" end)
        + " #" + (.number|tostring) + " " + .title + " | " + .url)
  end'

blocking="$(printf '%s\n' "$json" | jq --argjson history "$history" '[.[] | select(.state == "OPEN") | select((([.labels[]?.name] | any(. == "priority:critical" or . == "severity:blocking" or . == "bloquant")) or ((.title + " " + (.body // "")) | test("(?i)(bloquant|blocker|critical|critique)"))))] | length')"
if [ "${KIT_REPORT_FAIL_ON_BLOCKING:-0}" = 1 ] && [ "$blocking" -gt 0 ]; then
  echo "KIT-REPORTS: $blocking rapport(s) bloquant(s) doivent être traités avant une nouvelle tâche" >&2
  exit 2
fi
