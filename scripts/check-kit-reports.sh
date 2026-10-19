#!/usr/bin/env bash
set -euo pipefail

label="${KIT_REPORT_LABEL:-kit-report}"
repo="${KIT_REPORT_REPOSITORY:-}"

command -v gh >/dev/null 2>&1 || {
  echo "KIT-REPORTS: gh indisponible, lecture distante reportée" >&2
  exit 0
}

args=(issue list --state open --label "$label" --limit 100 --json number,title,body,labels,createdAt,url)
[ -n "$repo" ] && args+=(--repo "$repo")
json="$(gh "${args[@]}" 2>/dev/null || true)"
[ -n "$json" ] || { echo "KIT-REPORTS: aucune issue lisible"; exit 0; }

printf '%s\n' "$json" | jq -r '
  def blocking:
    ([.labels[]?.name] | any(. == "priority:critical" or . == "severity:blocking" or . == "bloquant"))
    or ((.title + " " + (.body // "")) | test("(?i)(bloquant|blocker|critical|critique)"));
  if length == 0 then
    "KIT-REPORTS: aucun rapport ouvert"
  else
    "KIT-REPORTS: rapports ouverts " + (length|tostring),
    (sort_by(if blocking then 0 else 1 end, .createdAt)
      | .[]
      | (if blocking then "BLOQUANT" else "NORMAL" end)
        + " #" + (.number|tostring) + " " + .title + " | " + .url)
  end'

blocking="$(printf '%s\n' "$json" | jq '[.[] | select((([.labels[]?.name] | any(. == "priority:critical" or . == "severity:blocking" or . == "bloquant")) or ((.title + " " + (.body // "")) | test("(?i)(bloquant|blocker|critical|critique)"))))] | length')"
if [ "${KIT_REPORT_FAIL_ON_BLOCKING:-0}" = 1 ] && [ "$blocking" -gt 0 ]; then
  echo "KIT-REPORTS: $blocking rapport(s) bloquant(s) doivent être traités avant une nouvelle tâche" >&2
  exit 2
fi
