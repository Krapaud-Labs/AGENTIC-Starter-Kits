#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for script in \
  "$root/starter-kit-codex/.codex/scripts/cleanup-integrated-branch.sh" \
  "$root/starter-kit-claude/.claude/scripts/cleanup-integrated-branch.sh"; do
  bash -n "$script"
  grep -Fq 'merge-base --is-ancestor' "$script"
  grep -Fq 'push origin --delete' "$script"
  grep -Fq 'branch -d' "$script"
  grep -Fq 'main|master|dev|develop' "$script"
done

echo "Nettoyage des branches intégrées Codex/Claude: OK"
