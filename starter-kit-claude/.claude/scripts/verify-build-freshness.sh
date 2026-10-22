#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 <source-dir> <expected-sha> [observed-image-sha] [target-branch]" >&2
  exit 2
fi
source_dir="$1"
expected_sha="$2"
observed_image_sha="${3:-$expected_sha}"
target_branch="${4:-}"
source_sha="$(git -C "$source_dir" rev-parse HEAD)"
branch="$(git -C "$source_dir" branch --show-current)"
if ! git -C "$source_dir" diff --quiet || ! git -C "$source_dir" diff --cached --quiet; then
  echo "BUILD-FRESHNESS: checkout modifié; build refusé" >&2
  exit 1
fi
if [ -n "$target_branch" ]; then
  case "$target_branch" in dev|main) ;; *) echo "BUILD-FRESHNESS: branche cible interdite: $target_branch" >&2; exit 1 ;; esac
  remote_sha="$(git -C "$source_dir" rev-parse "origin/$target_branch" 2>/dev/null || true)"
  if [ -z "$remote_sha" ] || [ "$source_sha" != "$remote_sha" ]; then
    echo "BUILD-FRESHNESS: checkout non aligné sur origin/$target_branch" >&2
    exit 1
  fi
fi
if [ "$source_sha" != "$expected_sha" ] || [ "$source_sha" != "$observed_image_sha" ]; then
  echo "BUILD-FRESHNESS: SHA divergent source=$source_sha image=$observed_image_sha attendu=$expected_sha branche=$branch" >&2
  exit 1
fi
echo "BUILD-FRESHNESS: OK branch=$branch sha=$source_sha"
