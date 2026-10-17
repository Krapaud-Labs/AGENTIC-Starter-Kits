#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
version="$(tr -d '[:space:]' < "$root/VERSION")"
for readme in README.md starter-kit-codex/README.md starter-kit-claude/README.md; do
  grep -Fq "$version" "$root/$readme" || { echo "Version absente de $readme: $version" >&2; exit 1; }
done
for kit in codex claude; do
  kit_file="$root/starter-kit-$kit/.${kit}/KIT.toml"
  grep -Fq "kit_version = \"$version\"" "$kit_file" || { echo "Version incohérente: $kit_file" >&2; exit 1; }
done
grep -Fq "version-" "$root/README.md" || { echo "Version absente du README principal" >&2; exit 1; }
grep -Fq "## $version -" "$root/CHANGELOG.md" || { echo "Entrée changelog absente: $version" >&2; exit 1; }
grep -Fq "| $version |" "$root/VERSION-HISTORY.md" || { echo "Entrée historique absente: $version" >&2; exit 1; }
bash "$root/scripts/audit-governance-consistency.sh"
printf 'Documentation et version cohérentes: %s\n' "$version"
