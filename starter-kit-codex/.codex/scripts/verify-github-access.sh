#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: verify-github-access.sh [--after-network-enabled-retry]

Run without options first. If that attempt cannot reach GitHub, rerun with
--after-network-enabled-retry only after the execution environment grants network access.
DNS failures remain inconclusive in both modes.
EOF
}

network_escalated=0
case "${1:-}" in
  "") ;;
  --after-network-enabled-retry) network_escalated=1 ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 64 ;;
esac
if [ "$#" -gt 1 ]; then usage >&2; exit 64; fi

timeout_seconds="${GITHUB_ACCESS_TIMEOUT_SECONDS:-8}"
found_gh=""
for candidate in "$(command -v gh 2>/dev/null || true)" /opt/homebrew/bin/gh /usr/local/bin/gh "$HOME/.local/bin/gh"; do
  if [ -n "$candidate" ] && [ -x "$candidate" ]; then found_gh="$candidate"; break; fi
done
[ -n "$found_gh" ] && echo "gh trouvé: $found_gh" || echo "gh absent des emplacements vérifiés"
if [ -n "$found_gh" ]; then
  "$found_gh" --version >/dev/null || { echo "gh trouvé mais inutilisable" >&2; exit 2; }
  "$found_gh" auth status >/dev/null 2>&1 && echo "gh authentifié" || echo "GH_AUTH_UNVERIFIED: authentification gh non vérifiée dans ce contexte (session limitée ou erreur locale)"
fi

curl_output=""
if curl_output="$(curl -fsSIL --max-time "$timeout_seconds" https://api.github.com 2>&1)"; then
  if [ "$network_escalated" -eq 1 ]; then
    echo "GitHub API accessible par curl après relance réseau renforcée"
  else
    echo "GitHub API accessible par curl"
  fi
  exit 0
else
  curl_status=$?
fi

if printf '%s' "$curl_output" | grep -Eiq 'sandbox|operation not permitted|permission denied|network is unreachable'; then
  if [ "$network_escalated" -eq 1 ]; then
    echo "SANDBOX_LIMITATION: curl reste bloqué par l'environnement malgré la relance réseau renforcée; utiliser le navigateur ou le connecteur GitHub." >&2
  else
    echo "SANDBOX_LIMITATION: curl est bloqué par l'environnement; relancer avec l'accès réseau renforcé ou le navigateur." >&2
  fi
  exit 2
fi

if [ "$curl_status" -eq 5 ] || [ "$curl_status" -eq 6 ] || printf '%s' "$curl_output" | grep -Eiq 'could not resolve|failed to resolve|name resolution|getaddrinfo|nodename nor servname'; then
  echo "DNS_RESOLUTION_FAILED: impossible de résoudre un nom d'hôte; cette erreur ne permet pas de conclure que GitHub est indisponible." >&2
  if [ "$network_escalated" -eq 0 ]; then
    echo "Après avoir accordé l'accès réseau renforcé, relancer: $0 --after-network-enabled-retry" >&2
  else
    echo "La résolution DNS échoue encore après la relance réseau renforcée; vérifier la configuration DNS ou le réseau de l'hôte." >&2
  fi
  exit 2
fi

if [ "$network_escalated" -eq 0 ]; then
  echo "NETWORK_ACCESS_UNVERIFIED: échec réseau avant l'essai avec accès renforcé; aucune indisponibilité externe n'est conclue." >&2
  echo "Après avoir accordé l'accès réseau renforcé, relancer: $0 --after-network-enabled-retry" >&2
  exit 2
fi

echo "GITHUB_EXTERNAL_UNAVAILABLE: GitHub reste inaccessible après la relance réseau renforcée (curl, code $curl_status)." >&2
exit 1
