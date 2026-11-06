#!/usr/bin/env bash
set -euo pipefail
status="${1:-}"; open_prs="${2:-}"; base="${3:-dev}"; branch="${4:-${GIT_BRANCH:-}}"; push_target="${5:-${GIT_PUSH_TARGET:-origin/${base}}}"
[ -n "$status" ] && [ -n "$open_prs" ] || { echo "Usage: validate-card-gitflow.sh <card-status> <open-pr-count> [base] [branch] [push-target]" >&2; exit 2; }
[[ "$open_prs" =~ ^[0-9]+$ ]] || { echo "GITFLOW: nombre de PR invalide" >&2; exit 1; }
[ "$base" = dev ] || [ "$base" = develop ] || { echo "GITFLOW: cible dev/develop obligatoire" >&2; exit 1; }
case "$branch" in main|master|dev|develop) echo "GITFLOW: branche dédiée obligatoire" >&2; exit 1;; esac
case "$push_target" in *main|*master) echo "GITFLOW: push direct protégé interdit" >&2; exit 1;; esac
[ "$open_prs" -le 1 ] || { echo "GITFLOW: mettre à jour la PR existante" >&2; exit 1; }
[ "$status" = complete ] && echo "GITFLOW: PR unique vers $base autorisée" || echo "GITFLOW: commits sur branche dédiée, PR différée"
