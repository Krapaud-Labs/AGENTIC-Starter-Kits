#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "RUNTIME: Docker CLI absent après découverte des outils" >&2
  exit 1
fi
docker_context="$(docker context show 2>/dev/null || true)"
docker_endpoint="$(docker context inspect "$docker_context" --format '{{.Endpoints.docker.Host}}' 2>/dev/null || true)"
if docker info >/dev/null 2>&1; then
  server="$(docker version --format '{{.Server.Version}}' 2>/dev/null || printf 'inconnu')"
  echo "RUNTIME: Docker prêt cli=présent daemon=accessible context=${docker_context:-inconnu} server=$server endpoint=${docker_endpoint:-inconnu}"
  exit 0
fi

# macOS peut conserver un contexte default cassé alors que Docker Desktop est prêt.
# Tester le contexte Desktop dans l'environnement de la session avant de conclure.
if [ "$(uname -s)" = "Darwin" ] && docker context inspect desktop-linux >/dev/null 2>&1; then
  desktop_endpoint="$(docker context inspect desktop-linux --format '{{.Endpoints.docker.Host}}' 2>/dev/null || true)"
  if DOCKER_CONTEXT=desktop-linux docker info >/dev/null 2>&1; then
    export DOCKER_CONTEXT=desktop-linux
    server="$(docker version --format '{{.Server.Version}}' 2>/dev/null || printf 'inconnu')"
    echo "RUNTIME: Docker prêt après sélection du contexte Desktop cli=présent daemon=accessible context=desktop-linux server=$server endpoint=${desktop_endpoint:-inconnu}"
    exit 0
  fi
fi
case "$(uname -s)" in
  Darwin) open -a Docker >/dev/null 2>&1 || true ;;
  Linux) systemctl --user start docker >/dev/null 2>&1 || systemctl start docker >/dev/null 2>&1 || true ;;
esac
for _ in $(seq 1 30); do
  if docker info >/dev/null 2>&1; then
    echo "RUNTIME: daemon Docker démarré et prêt"
    exit 0
  fi
  sleep 2
done
echo "RUNTIME: Docker non prêt cli=présent daemon=inaccessible context=${docker_context:-inconnu} endpoint=${docker_endpoint:-inconnu}; démarrage tenté" >&2
exit 1
