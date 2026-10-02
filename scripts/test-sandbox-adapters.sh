#!/usr/bin/env bash
set -euo pipefail
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
fail() { echo "ECHEC ADAPTATEURS SANDBOX: $*" >&2; exit 1; }

mkdir -p "$tmp/trello"
printf '%s\n' 'Feature' 'Frontend' 'QA' > "$tmp/trello/labels"
printf '%s\t%s\t%s\n' 'P23' 'À concevoir' 'Feature,Frontend,QA' > "$tmp/trello/cards.tsv"
grep -q $'^P23\tÀ concevoir\tFeature,Frontend,QA$' "$tmp/trello/cards.tsv" || fail 'carte ou labels incorrects'
printf '%s\n' 'Séparer les dashboards' 'Valider les routes protégées' > "$tmp/trello/P23.checks"
[ "$(wc -l < "$tmp/trello/P23.checks" | tr -d ' ')" = 2 ] || fail 'checklist incomplète'
printf '%s\n' 'connector=unavailable' 'browser=used' 'visual_readback=verified' > "$tmp/trello/fallback"
grep -q 'visual_readback=verified' "$tmp/trello/fallback" || fail 'fallback non relu'

printf '%s\n' 'MVP-001' 'MVP-002' 'MVP-003' > "$tmp/order"
awk -F- 'BEGIN{p=0} {n=$2+0; if(n!=p+1) exit 1; p=n}' "$tmp/order" || fail 'ordre invalide'
printf '%s\t%s\n' 'agent-frontend' 'src/ui' > "$tmp/agents"
printf '%s\t%s\n' 'agent-qa' 'tests/ui' >> "$tmp/agents"
awk -F '\t' 'seen[$2]++{exit 1}' "$tmp/agents" || fail 'lots qui se chevauchent'
grep -q agent-frontend "$tmp/agents" || fail 'agent absent'
grep -q agent-qa "$tmp/agents" || fail 'agent absent'

printf '%s\n' 'P23->dev' 'dev->main' > "$tmp/gitflow"
[ "$(wc -l < "$tmp/gitflow" | tr -d ' ')" = 2 ] || fail 'GitFlow incomplet'
printf '%s\n' 'session_status=closed' 'open_tabs=none' 'shutdown_evidence=verified' > "$tmp/browser"
grep -q '^session_status=closed$' "$tmp/browser" || fail 'session ouverte'
grep -q '^open_tabs=none$' "$tmp/browser" || fail 'onglets ouverts'
echo "Adaptateurs sandbox simulés OK"
