#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for file in "$root/starter-kit-codex/.codex/skills/project-onboarding/SKILL.md" "$root/starter-kit-claude/.claude/skills/project-onboarding/SKILL.md"; do
  rg -q 'parcours accéléré de reprise' "$file"
  rg -q '20 minutes actives, 30 actions maximum' "$file"
  rg -q 'Une relecture complète intervient.*carte' "$file"
done
echo "EXISTING-PROJECT-FAST-PATH: OK"
