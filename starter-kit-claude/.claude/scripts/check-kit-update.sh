#!/usr/bin/env bash
set -euo pipefail
config="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
local_version="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$config/KIT.toml")"
project_root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || (cd "$config/.." && pwd))"
manifest="$project_root/.workspace.toml"
source_url="${AGENTIC_KIT_SOURCE:-}"
if [ -z "$source_url" ] && [ -f "$manifest" ]; then
  source_url="$(sed -n 's/^source = "\(.*\)"/\1/p' "$manifest")"
fi
source_url="${source_url:-https://raw.githubusercontent.com/Krapaud-Labs/AGENTIC-Starter-Kits/main/VERSION}"
if [[ "$source_url" == https://github.com/* ]]; then
  source_url="https://raw.githubusercontent.com/${source_url#https://github.com/}"
fi
source_url="${source_url%/}"
source_url="${source_url%.git}"
case "$source_url" in */VERSION) ;; *) source_url="${source_url}/main/VERSION" ;; esac
printf 'Version locale du kit: %s\n' "$local_version"
printf 'Source distante du kit: %s\n' "$source_url"
if ! command -v curl >/dev/null 2>&1; then echo 'Vérification distante impossible: curl absent' >&2; exit 2; fi
remote_version="$(curl --fail --silent --show-error --location --max-time 10 "${source_url}?_kit_check=$(date +%s)" | tr -d '[:space:]')" || { echo 'Vérification distante impossible: source indisponible' >&2; exit 2; }
if [[ "$source_url" == https://raw.githubusercontent.com/Krapaud-Labs/AGENTIC-Starter-Kits/main/VERSION ]] && command -v gh >/dev/null 2>&1; then
  remote_version="$(gh api 'repos/Krapaud-Labs/AGENTIC-Starter-Kits/contents/VERSION?ref=main' --jq .content | tr -d '\n' | base64 --decode | tr -d '[:space:]')"
fi
printf 'Version distante du kit: %s\n' "$remote_version"
if [ "$local_version" = "$remote_version" ]; then echo 'Kit à jour'; else echo "Mise à jour du kit disponible: $local_version -> $remote_version"; exit 3; fi
