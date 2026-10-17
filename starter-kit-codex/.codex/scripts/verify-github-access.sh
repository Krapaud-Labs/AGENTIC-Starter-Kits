#!/usr/bin/env bash
set -euo pipefail

timeout_seconds="${GITHUB_ACCESS_TIMEOUT_SECONDS:-8}"
found_gh=""
for candidate in "$(command -v gh 2>/dev/null || true)" /opt/homebrew/bin/gh /usr/local/bin/gh "$HOME/.local/bin/gh"; do
  if [ -n "$candidate" ] && [ -x "$candidate" ]; then found_gh="$candidate"; break; fi
done
[ -n "$found_gh" ] && echo "gh trouvé: $found_gh" || echo "gh absent des emplacements vérifiés"
if [ -n "$found_gh" ]; then
  "$found_gh" --version >/dev/null || { echo "gh trouvé mais inutilisable" >&2; exit 2; }
  "$found_gh" auth status >/dev/null 2>&1 && echo "gh authentifié" || echo "gh non authentifié ou session limitée"
fi

if curl_output="$(curl -fsSIL --max-time "$timeout_seconds" https://api.github.com 2>&1)"; then
  echo "GitHub API accessible par curl"
  exit 0
fi
case "$curl_output" in
  *sandbox*|*'operation not permitted'*|*'permission denied'*|*'Network is unreachable'*)
    echo "SANDBOX_LIMITATION: curl bloqué par l'environnement; relancer avec l'accès réseau renforcé ou le navigateur." >&2
    exit 2
    ;;
  *)
    echo "GITHUB_EXTERNAL_UNAVAILABLE: échec observable de l'accès API après vérification curl." >&2
    exit 1
    ;;
esac
