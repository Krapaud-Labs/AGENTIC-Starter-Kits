#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: validate-card-gitflow.sh <card-status> <open-pr-count> [base] [branch] [push-target]" >&2
  exit 2
}

status="${1:-}"
open_prs="${2:-}"
base="${3:-dev}"
branch="${4:-${GIT_BRANCH:-}}"
push_target="${5:-${GIT_PUSH_TARGET:-origin/${base}}}"
[ -n "$status" ] && [ -n "$open_prs" ] || usage
[[ "$open_prs" =~ ^[0-9]+$ ]] || { echo "GITFLOW: nombre de PR invalide" >&2; exit 1; }
[ "$base" = "dev" ] || [ "$base" = "develop" ] || {
  echo "GITFLOW: la PR de carte doit cibler dev ou develop" >&2; exit 1;
}
[ -z "$branch" ] || {
  case "$branch" in main|master|dev|develop)
    echo "GITFLOW: une carte doit utiliser une branche dédiée" >&2; exit 1;;
  esac
}
case "$push_target" in *main|*master) echo "GITFLOW: push direct vers une branche protégée interdit" >&2; exit 1;; esac
[ "$open_prs" -le 1 ] || { echo "GITFLOW: mettre à jour la PR existante" >&2; exit 1; }
if [ "$status" != "complete" ] && [ "$open_prs" -eq 1 ]; then
  echo "GITFLOW: PR existante conservée comme unique PR, aucune nouvelle PR" >&2
fi
if [ "$status" != "complete" ]; then
  echo "GITFLOW: commits autorisés sur la branche dédiée, PR finale différée"; exit 0
fi
echo "GITFLOW: PR unique vers $base autorisée"
