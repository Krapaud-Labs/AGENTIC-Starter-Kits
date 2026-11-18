#!/usr/bin/env bash
set -euo pipefail
config="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
local_version="$(sed -n 's/^kit_version = "\(.*\)"/\1/p' "$config/KIT.toml")"
project_root="$(git rev-parse --show-toplevel 2>/dev/null || (cd "$config/.." && pwd))"
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
cache="$config/.kit-remote-version-cache"
cache_ttl="${AGENTIC_KIT_CHECK_TTL_SECONDS:-300}"
now="$(date +%s)"
remote_version=""
cache_hit=false
if [ "${AGENTIC_KIT_CHECK_FORCE:-0}" != "1" ] && [ -s "$cache" ]; then
  IFS=$'\t' read -r cached_at cached_source cached_version < "$cache" || true
  if [ "$cached_source" = "$source_url" ] && [ -n "$cached_version" ] && [ "$cached_at" -ge 0 ] 2>/dev/null && [ $((now - cached_at)) -lt "$cache_ttl" ]; then
    remote_version="$cached_version"
    cache_hit=true
    echo "Vérification distante réutilisée depuis le cache (${cache_ttl}s)"
  fi
fi
if [ -z "$remote_version" ]; then
  remote_version="$(curl --fail --silent --show-error --location --max-time 10 "${source_url}?_kit_check=$now" | tr -d '[:space:]')" || { echo 'Vérification distante impossible: source indisponible' >&2; exit 2; }
fi
if [ "$cache_hit" = false ] && [[ "$source_url" == https://raw.githubusercontent.com/Krapaud-Labs/AGENTIC-Starter-Kits/main/VERSION ]] && command -v gh >/dev/null 2>&1; then
  gh_version="$(gh api 'repos/Krapaud-Labs/AGENTIC-Starter-Kits/contents/VERSION?ref=main' --jq .content 2>/dev/null | tr -d '\n' | base64 --decode | tr -d '[:space:]' || true)"
  [ -n "$gh_version" ] && remote_version="$gh_version"
fi
printf '%s\t%s\t%s\n' "$now" "$source_url" "$remote_version" > "$cache"
printf 'Version distante du kit: %s\n' "$remote_version"
version_key() { local a b c; IFS=. read -r a b c _ <<< "$1"; printf '%03d%03d%03d' "${a:-0}" "${b:-0}" "${c:-0}"; }
if [ "$(version_key "$local_version")" -ge "$(version_key "$remote_version")" ]; then echo 'Kit à jour'; else echo "Mise à jour du kit disponible: $local_version -> $remote_version"; exit 3; fi
