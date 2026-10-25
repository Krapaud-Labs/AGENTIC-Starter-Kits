#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for policy in "$root/starter-kit-codex/.codex/policies/PROJECT-TRACKER-VISUAL-SYSTEM.md" "$root/starter-kit-claude/.claude/policies/PROJECT-TRACKER-VISUAL-SYSTEM.md"; do
  test -s "$policy"
  rg -q 'Trello et GitHub Projects' "$policy"
rg -q 'Une carte ne peut jamais être `Terminé` tout en restant `Draft Issue`' "$policy"
rg -q 'convertir les brouillons déjà terminés en Issues' "$policy"
rg -q 'Pour une carte terminée' "$policy"
  rg -q 'rubriques Markdown explicites' "$policy"
  rg -q 'Backlog.*In progress.*Done' "$policy"
  rg -q 'MVP-001.*POST-MVP-001' "$policy"
  rg -q 'Fonctionnalité.*Anomalie.*Sécurité' "$policy"
  rg -q 'connecteur en lecture-écriture' "$policy"
  rg -q 'liste de tâches Markdown' "$policy"
  rg -q 'une seule PR finale' "$policy"
  rg -q 'README.*documentation.*changelog' "$policy"
done
for wrapper in "$root/starter-kit-codex/.codex/policies/TRELLO-VISUAL-SYSTEM.md" "$root/starter-kit-claude/.claude/policies/TRELLO-VISUAL-SYSTEM.md"; do rg -q 'PROJECT-TRACKER-VISUAL-SYSTEM.md' "$wrapper"; done
echo "PROJECT-TRACKER-POLICY: OK"
