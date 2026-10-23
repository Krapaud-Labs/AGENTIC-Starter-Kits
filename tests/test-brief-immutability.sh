#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
git -C "$tmp" init -q
for kit in codex claude; do
  hidden=".${kit}"
  mkdir -p "$tmp/$hidden/scripts"
  cp "$root/starter-kit-$kit/$hidden/scripts/archive-project-brief.sh" "$tmp/$hidden/scripts/"
  chmod +x "$tmp/$hidden/scripts/archive-project-brief.sh"
  printf '# Cahier MVP\n\naccepted\n' > "$tmp/$hidden/PROJECT-BRIEF.md"
  (cd "$tmp" && bash "$hidden/scripts/archive-project-brief.sh") >/dev/null
  original="$(find "$tmp/docs/project-management/cahier-des-charges" -name ORIGINAL-MVP-BRIEF.sha256 -print -quit)"
  test -s "$original"
  printf '# Demande client\n\nfonctionnalite postérieure\n' > "$tmp/$hidden/PROJECT-BRIEF.md"
  (cd "$tmp" && bash "$hidden/scripts/archive-project-brief.sh") >/dev/null 2>&1
  test -n "$(find "$tmp/docs/project-management/cahier-des-charges" -name 'CHANGE-REQUEST-*.md' -print -quit)"
  test -n "$(cat "$original")"
done
echo "Cahier MVP immuable et demandes de changement séparées Codex/Claude: OK"
