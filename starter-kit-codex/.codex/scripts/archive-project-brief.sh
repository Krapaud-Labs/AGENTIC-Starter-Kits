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
original="$archive_dir/ORIGINAL-MVP-BRIEF.sha256"
mkdir -p "$archive_dir"
if [ ! -e "$original" ]; then
  printf '%s\n' "$fingerprint" > "$original"
  cp "$brief" "$archive"
  echo "CAHIER: référence MVP initiale archivée $archive"
elif [ "$(tr -d '[:space:]' < "$original")" != "$fingerprint" ]; then
  change="$archive_dir/CHANGE-REQUEST-$fingerprint.md"
  if [ ! -e "$change" ]; then
    printf '%s\n' '# Demande de changement du cahier MVP' '' '- Le cahier initial reste immuable.' '- Cette version diffère de la référence originale.' "- Empreinte originale: $(cat "$original")" "- Empreinte observée: $fingerprint" '- Traiter cette évolution séparément comme demande de changement et décider MVP ou Post-MVP.' > "$change"
  fi
  echo "CAHIER: modification détectée; demande de changement créée $change" >&2
elif [ ! -e "$archive" ]; then
  cp "$brief" "$archive"
  echo "CAHIER: archive persistante créée $archive"
else
  echo "CAHIER: archive déjà présente $archive"
fi
