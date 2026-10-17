#!/usr/bin/env bash
set -euo pipefail
root="$(git rev-parse --show-toplevel 2>/dev/null || { echo 'GITFLOW: dépôt Git requis' >&2; exit 1; })"
lock="$root/.git/index.lock"
[ -e "$lock" ] || { echo 'Git index lock absent'; exit 0; }

if ! command -v lsof >/dev/null 2>&1 && ! command -v fuser >/dev/null 2>&1; then
  echo 'GITFLOW: impossible de distinguer un verrou actif sans lsof ou fuser; installation requise' >&2
  exit 1
fi
lock_holder() {
  if command -v lsof >/dev/null 2>&1; then lsof "$lock" 2>/dev/null; else fuser "$lock" 2>/dev/null; fi
}

for _ in 1 2 3; do
  if lock_holder >/dev/null 2>&1; then
    echo "GITFLOW: index.lock actif, processus propriétaire détecté" >&2
    lock_holder >&2 || true
    exit 1
  fi
  sleep 1
done

if lock_holder >/dev/null 2>&1; then
  echo 'GITFLOW: index.lock devenu actif pendant le diagnostic' >&2
  exit 1
fi
quarantine="${TMPDIR:-/tmp}/agentic-index-lock-$(date +%Y%m%d-%H%M%S)-$$"
mv "$lock" "$quarantine"
echo "GITFLOW: verrou Git orphelin déplacé vers $quarantine"
