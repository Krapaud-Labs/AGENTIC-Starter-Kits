#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for kit in codex claude; do
  if [ "$kit" = codex ]; then
    hidden=.codex
    script="$root/starter-kit-codex/.codex/scripts/bind-session.sh"
    policy="$root/starter-kit-codex/.codex/policies/SESSION-ISOLATION-POLICY.md"
  else
    hidden=.claude
    script="$root/starter-kit-claude/.claude/scripts/bind-session.sh"
    policy="$root/starter-kit-claude/.claude/policies/SESSION-ISOLATION-POLICY.md"
  fi
  bash -n "$script"
  grep -Fq 'NATIVE_GOAL_ID' "$script"
  grep -Fq 'scope déjà lié à une autre branche' "$script"
  grep -Fq 'bind-session.sh' "$policy"
done

echo "Isolation des conversations Codex/Claude: OK"
