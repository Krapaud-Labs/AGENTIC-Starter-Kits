#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "${KIT_PROJECT_ROOT:-$PWD}" rev-parse --show-toplevel 2>/dev/null || cd "$config/.." && pwd)"
manifest="$config/.context-manifest.tsv"
hash_file() { if command -v shasum >/dev/null 2>&1; then shasum -a 256 "$1" | cut -d' ' -f1; else sha256sum "$1" | cut -d' ' -f1; fi; }
mkdir -p "$config"
tmp="$manifest.tmp"
printf 'path\tbytes\tsha256\tupdated_at\n' > "$tmp"
for relative in AGENTS.md "$config"/ORCHESTRATION.md "$config"/project-profile.toml "$config"/RUNTIME-STATE.md; do
  case "$relative" in /*) file="$relative"; path="${relative#"$config"/}" ;; *) file="$root/$relative"; path="$relative" ;; esac
  [ -f "$file" ] || continue
  printf '%s\t%s\t%s\t%s\n' "$path" "$(wc -c < "$file" | tr -d ' ')" "$(hash_file "$file")" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$tmp"
done
mv "$tmp" "$manifest"
echo "Manifeste contexte mis à jour : $manifest"
