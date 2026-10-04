#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || { echo "GITFLOW: dépôt Git requis avant modification" >&2; exit 1; })"
branch="$(git -C "$root" branch --show-current)"
case "$branch" in
  main|master|dev|develop) echo "GITFLOW: travail interdit directement sur $branch" >&2; exit 1 ;;
  feat/*|feature/*|fix/*|hotfix/*|chore/*|docs/*|refactor/*|test/*) ;;
  *) echo "GITFLOW: branche dédiée invalide $branch" >&2; exit 1 ;;
esac
[ ! -e "$root/.git/index.lock" ] || { echo "GITFLOW: index.lock présent" >&2; exit 1; }
git -C "$root" diff --check
echo "Validation Git Flow avant travail OK: $branch"
