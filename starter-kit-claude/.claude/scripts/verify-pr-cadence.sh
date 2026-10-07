#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: verify-pr-cadence.sh <card-status> <existing-pr-count> [deployment-checkpoint]" >&2
  exit 2
}

status="${1:-}"
existing="${2:-}"
exception="${3:-none}"
[ -n "$status" ] && [ -n "$existing" ] || usage
[[ "$existing" =~ ^[0-9]+$ ]] || { echo "PR-CADENCE: nombre de PR invalide" >&2; exit 1; }

if [ "$existing" -gt 1 ]; then
  echo "PR-CADENCE: plusieurs PR pour la même carte, mettre à jour la PR existante" >&2
  exit 1
fi

if [ "$status" != "complete" ] && [ "$exception" != "deployment-checkpoint" ]; then
  echo "PR-CADENCE: PR interdite avant la Definition of Done de la carte" >&2
  exit 1
fi

if [ "$status" != "complete" ]; then
  echo "PR-CADENCE: checkpoint de déploiement explicitement autorisé, la carte reste ouverte"
else
  echo "PR-CADENCE: PR finale autorisée, utiliser la branche existante si une PR existe déjà"
fi
