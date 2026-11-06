#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for kit in codex claude; do
  hidden=".$kit"
  bash "$root/starter-kit-$kit/$hidden/scripts/validate-goal-budget.sh" >/dev/null
done

for pair in 'GOAL_MAX_MINUTES 31' 'GOAL_MAX_STEPS 41' 'GOAL_MAX_TOKENS 50001' 'GOAL_MAX_RETRIES 3' 'GOAL_MAX_AGENTS 4'; do
  set -- $pair
  if env "$1=$2" bash "$root/starter-kit-codex/.codex/scripts/validate-goal-budget.sh" >/dev/null 2>&1; then
    echo "BUDGET: dépassement accepté pour $1" >&2
    exit 1
  fi
done

python3 -m unittest scripts.test_context_token_audit >/dev/null
echo 'Contrôles coûts et contexte agentique: OK'
