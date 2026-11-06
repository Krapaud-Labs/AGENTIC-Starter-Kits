#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

for sync in \
  "$root/starter-kit-codex/.codex/scripts/sync-workspace-kit.sh" \
  "$root/starter-kit-claude/.claude/scripts/sync-workspace-kit.sh"; do
  bash -n "$sync"
  grep -Fq 'sync-workspace-kit.lock' "$sync"
  grep -Fq 'operation.phase' "$sync"
  grep -Fq "printf 'prepared\\n'" "$sync"
  grep -Fq "printf 'applied\\n'" "$sync"
  grep -Fq "printf 'validated\\n'" "$sync"
  grep -Fq "printf 'committed\\n'" "$sync"
  grep -Fq 'rsync -a --delete' "$sync"
done

if ! grep -Fq 'if [ ! -f "$project_root/AGENTS.md" ]; then' \
  "$root/starter-kit-codex/.codex/scripts/sync-workspace-kit.sh"; then
  echo 'ÉCHEC: AGENTS.md consommateur pourrait être écrasé' >&2
  exit 1
fi

echo 'Synchronisation shared transactionnelle: contrôles statiques OK'
