#!/usr/bin/env bash
set -euo pipefail

integration="${1:-}"
branch="${2:-$(git branch --show-current)}"
[ "$integration" = "dev" ] || [ "$integration" = "develop" ] || { echo "GITFLOW: branche d intégration attendue dev ou develop" >&2; exit 2; }
[ -n "$branch" ] || { echo "GITFLOW: branche de travail absente" >&2; exit 2; }
case "$branch" in main|master|dev|develop) echo "GITFLOW: suppression d une branche protégée interdite" >&2; exit 2 ;; esac
root="$(git rev-parse --show-toplevel)"
[ -z "$(git -C "$root" status --porcelain)" ] || { echo "GITFLOW: changements locaux non commités" >&2; exit 3; }
git -C "$root" fetch origin "$integration"
git -C "$root" show-ref --verify --quiet "refs/heads/$branch" || { echo "GITFLOW: branche locale absente" >&2; exit 4; }
git -C "$root" merge-base --is-ancestor "$branch" "origin/$integration" || { echo "GITFLOW: branche non fusionnée dans $integration" >&2; exit 5; }
current="$(git -C "$root" branch --show-current)"
if [ "$current" = "$branch" ]; then git -C "$root" switch "$integration" 2>/dev/null || git -C "$root" switch -c "$integration" "origin/$integration"; fi
if git -C "$root" ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then git -C "$root" push origin --delete "$branch"; fi
git -C "$root" branch -d "$branch"
echo "GITFLOW: branche $branch supprimée localement et sur origin après fusion dans $integration"
