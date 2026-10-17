#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "RUNTIME: Docker CLI absent après découverte des outils" >&2
  exit 1
fi
if docker info >/dev/null 2>&1; then
  echo "RUNTIME: daemon Docker déjà prêt"
  exit 0
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
echo "RUNTIME: daemon Docker toujours indisponible après tentative de démarrage" >&2
exit 1
