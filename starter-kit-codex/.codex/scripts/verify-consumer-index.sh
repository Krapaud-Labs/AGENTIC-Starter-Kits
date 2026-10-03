#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config_root="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config_root/.." rev-parse --show-toplevel 2>/dev/null || true)"
[ -n "$root" ] || { echo "ECHEC KIT: dépôt Git requis" >&2; exit 2; }

# Le dépôt source est le seul endroit où le kit distribué est suivi.
if git -C "$root" ls-files --error-unmatch starter-kit-codex/.codex/KIT.toml >/dev/null 2>&1; then
  echo "Contrôle index consommateur ignoré dans le dépôt source du kit"
  exit 0
fi

local_dir=".codex"
if ! git -C "$root" check-ignore -q "$root/$local_dir/RUNTIME-STATE.md"; then
  echo "ECHEC KIT: $local_dir/ doit être ignoré dans un projet consommateur" >&2
  exit 1
fi

tracked="$(git -C "$root" ls-files -- "$local_dir/")"
staged="$(git -C "$root" diff --cached --name-only -- "$local_dir/")"
if [ -n "$tracked" ] || [ -n "$staged" ]; then
  echo "ECHEC KIT: $local_dir/ est présent dans l’index Git du projet consommateur" >&2
  printf '%s\n' "$tracked" "$staged" | sed '/^$/d' | sort -u >&2
  echo "Correction sûre: git rm -r --cached -- $local_dir (les fichiers locaux sont conservés)" >&2
  exit 1
fi

echo "Contrôle index consommateur OK"
