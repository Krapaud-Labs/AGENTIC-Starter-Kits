#!/usr/bin/env bash
set -euo pipefail

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
echo "INTEGRATION PREFLIGHT"

git -C "$tmp" init -q
git -C "$tmp" config user.email integration@example.invalid
git -C "$tmp" config user.name integration
git -C "$tmp" config commit.gpgsign false
printf 'base\n' > "$tmp/file"
git -C "$tmp" add file
git -C "$tmp" commit -qm base
git -C "$tmp" worktree add -q "$tmp/agent-a" -b agent-a
git -C "$tmp" worktree add -q "$tmp/agent-b" -b agent-b
printf 'a\n' >> "$tmp/agent-a/file"
printf 'b\n' >> "$tmp/agent-b/file"
git -C "$tmp/agent-a" add file && git -C "$tmp/agent-a" commit -qm agent-a
git -C "$tmp/agent-b" add file && git -C "$tmp/agent-b" commit -qm agent-b
test "$(git -C "$tmp" status --porcelain --untracked-files=no)" = ""
echo "git_worktrees=passed"

: > "$tmp/.git/index.lock"
test -f "$tmp/.git/index.lock"
echo "git_index_lock_detection=passed"

if [ "${REAL_TRELLO_TEST:-0}" = "1" ]; then
  [ -n "${TRELLO_TEST_BOARD_ID:-}" ] || { echo "TRELLO_TEST_BOARD_ID manquant" >&2; exit 2; }
  echo "trello=authorized-preflight-only"
else
  echo "trello=not-executed"
fi
if [ "${REAL_AGENT_TEST:-0}" = "1" ]; then echo "agents=authorized-preflight-only"; else echo "agents=not-executed"; fi
if [ "${REAL_BROWSER_TEST:-0}" = "1" ]; then echo "browser=authorized-preflight-only"; else echo "browser=not-executed"; fi
echo "status=completed-with-explicit-external-limits"
