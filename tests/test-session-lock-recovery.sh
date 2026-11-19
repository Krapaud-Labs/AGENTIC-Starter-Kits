#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for script in \
  "$root/starter-kit-codex/.codex/scripts/session-start-gate.sh" \
  "$root/starter-kit-claude/.claude/scripts/session-start-gate.sh"; do
  bash -n "$script"
  grep -Fq 'lock_owner="$session_lock/pid"' "$script"
  grep -Fq 'kill -0 "$lock_pid"' "$script"
  grep -Fq 'stat -c %Y "$session_lock"' "$script"
  grep -Fq ' -gt 120 ' "$script"
done

echo "Récupération des verrous de session périmés: OK"
