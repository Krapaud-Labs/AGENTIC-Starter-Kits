#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex="$root/starter-kit-codex/AGENTS.md"
claude="$root/starter-kit-claude/CLAUDE.md"

for entrypoint in "$codex" "$claude"; do
  grep -Fq '.workspace.toml' "$entrypoint"
  grep -Fq 'doit être livré avec le travail en cours' "$entrypoint"
  grep -Fq 'ne jamais le laisser volontairement en attente' "$entrypoint"
done

echo "Livraison du manifeste .workspace.toml: OK"
