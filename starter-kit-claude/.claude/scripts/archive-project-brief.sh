#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
if root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  :
else
  root="$(cd "$config/.." && pwd)"
fi
brief="$config/PROJECT-BRIEF.md"
[ -s "$brief" ] || exit 0
project="$(basename "$root")"
archive_dir="$root/docs/project-management/cahier-des-charges/$project"
fingerprint="$(shasum -a 256 "$brief" | awk '{print $1}')"
archive="$archive_dir/PROJECT-BRIEF-$fingerprint.md"
mkdir -p "$archive_dir"
if [ ! -e "$archive" ]; then
  cp "$brief" "$archive"
  echo "CAHIER: archive persistante créée $archive"
else
  echo "CAHIER: archive déjà présente $archive"
fi
