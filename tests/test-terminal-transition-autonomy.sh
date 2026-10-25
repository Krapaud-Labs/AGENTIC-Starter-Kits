#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

for policy in \
  "$root/starter-kit-codex/.codex/policies/AUTONOMY-AND-RECOVERY.md" \
  "$root/starter-kit-claude/.claude/policies/AUTONOMY-AND-RECOVERY.md"; do
  grep -q "écrit lui-même l'état terminal" "$policy"
  grep -q "ne demande jamais une phrase d'autorisation" "$policy"
  grep -q 'ne doit pas remettre `delivery-gate` à `pending`' "$policy"
done

echo "PASS: transition terminale autonome couverte par les deux kits"
