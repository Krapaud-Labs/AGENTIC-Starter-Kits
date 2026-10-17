#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
version_file="$root/VERSION"
[ -f "$version_file" ] || { echo "VERSION manquant"; exit 1; }
version="$(tr -d '[:space:]' < "$version_file")"
case "$version" in
  0|[0-9]*.[0-9]*.[0-9]*) ;;
  *) echo "Version SemVer invalide: $version"; exit 1 ;;
esac
if ! [[ "$version" =~ ^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$ ]]; then
  echo "Version SemVer invalide: $version"
  exit 1
fi
printf 'Version SemVer OK: %s\n' "$version"

for file in "$root/README.md" "$root/starter-kit-codex/README.md" "$root/starter-kit-claude/README.md" "$root/starter-kit-codex/.codex/KIT.toml" "$root/starter-kit-claude/.claude/KIT.toml"; do
  grep -Fq "$version" "$file" || { echo "Version périmée dans $file"; exit 1; }
done
history_current="$(awk -F'|' '/^\| [0-9]+\.[0-9]+\.[0-9]+ \|/ {gsub(/ /, "", $2); print $2; exit}' "$root/VERSION-HISTORY.md")"
[ "$history_current" = "$version" ] || { echo "Historique périmé: $history_current au lieu de $version"; exit 1; }
duplicate_versions="$(grep -E '^## [0-9]+\.[0-9]+\.[0-9]+' "$root/CHANGELOG.md" | sed -E 's/^## ([0-9]+\.[0-9]+\.[0-9]+).*/\1/' | sort | uniq -d)"
[ -z "$duplicate_versions" ] || { echo "Versions dupliquées dans CHANGELOG.md: $duplicate_versions"; exit 1; }
