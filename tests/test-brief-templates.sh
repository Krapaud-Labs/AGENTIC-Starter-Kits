#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
for hidden in .codex .claude; do
  dir="$root/starter-kit-${hidden#.}/$hidden/templates"
  for file in project-brief.md project-brief-blank.md reconstruction-existing-project.md change-request-post-mvp.md; do test -s "$dir/$file"; done
  rg -q 'Périmètre MVP' "$dir/project-brief.md"
  rg -q 'Statut obligatoire initial.*pending' "$dir/project-brief-blank.md"
  rg -q 'reconstructed' "$dir/reconstruction-existing-project.md"
  rg -q 'ne modifie jamais le cahier initial' "$dir/change-request-post-mvp.md"
done
echo "BRIEF-TEMPLATES: OK"
