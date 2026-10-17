#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 AAAA-MM-JJ-identifiant-court"
  exit 2
fi

identifier="$1"
case "$identifier" in
  ????-??-??-*[!a-z0-9-]*|????-??-??-) echo "Identifiant invalide"; exit 2 ;;
esac

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || (cd "$config/.." && pwd))"
target="$config/work-items/$identifier"
[ ! -e "$target" ] || { echo "Work item existant: $target"; exit 1; }
mkdir "$target"
sed "s/<identifiant>/$identifier/" "$config/templates/work-item.md" > "$target/brief.md"
cp "$config/templates/obligation-register.tsv" "$target/obligations.tsv"
echo "Work item créé: $target/brief.md"
