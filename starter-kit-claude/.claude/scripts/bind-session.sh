#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config="$(cd "$script_dir/.." && pwd)"
root="$(git -C "$config/.." rev-parse --show-toplevel 2>/dev/null || cd "$config/.." && pwd)"
scope="${1:-${AGENTIC_SESSION_ID:-${CLAUDE_SESSION_ID:-${NATIVE_GOAL_ID:-unscoped}}}}"
scope="$(printf '%s' "$scope" | tr -cs 'A-Za-z0-9._-' '-' | sed 's/^-*//; s/-*$//')"
[ -n "$scope" ] || scope=unscoped
sessions="$config/sessions"
session_dir="$sessions/$scope"
mkdir -p "$session_dir"
branch="$(git -C "$root" branch --show-current 2>/dev/null || echo unknown)"
work_item="$(sed -n 's/^- Work item actif: *//p' "$config/RUNTIME-STATE.md" 2>/dev/null | head -1 || echo none)"
manifest="$session_dir/SESSION-MANIFEST.md"
if [ -f "$manifest" ] && ! grep -Fq -- "- Branche: $branch" "$manifest"; then
  echo "SESSION: scope déjà lié à une autre branche" >&2
  exit 4
fi
if [ ! -f "$manifest" ]; then
  {
    echo "# Manifeste de session"
    echo
    echo "- Scope: $scope"
    echo "- Branche: $branch"
    echo "- Work item: $work_item"
    echo "- Projet: $root"
    echo "- Créé: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  } > "$manifest"
fi
printf 'SESSION_SCOPE=%s\nSESSION_BRANCH=%s\nSESSION_WORK_ITEM=%s\n' "$scope" "$branch" "$work_item"
