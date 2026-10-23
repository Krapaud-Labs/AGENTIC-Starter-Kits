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
  printf '# Cahier\n\n## Statut\n\naccepted\n' > "$tmp/$hidden/PROJECT-BRIEF.md"
  (cd "$tmp" && bash "$hidden/scripts/archive-project-brief.sh") >/dev/null
  archive_count="$(find "$tmp/docs/project-management/cahier-des-charges" -type f -name 'PROJECT-BRIEF-*.md' | wc -l | tr -d ' ')"
  test "$archive_count" -eq 1
  first="$(find "$tmp/docs/project-management/cahier-des-charges" -type f -name 'PROJECT-BRIEF-*.md' -print -quit)"
  (cd "$tmp" && bash "$hidden/scripts/archive-project-brief.sh") >/dev/null
  test "$(find "$tmp/docs/project-management/cahier-des-charges" -type f -name 'PROJECT-BRIEF-*.md' | wc -l | tr -d ' ')" -eq 1
  test -s "$first"
done
echo "Archive persistante et dédupliquée du cahier Codex/Claude: OK"
