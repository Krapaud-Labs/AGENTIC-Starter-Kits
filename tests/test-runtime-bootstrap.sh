#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
git -C "$tmp" init -q
for kit in codex claude; do
  hidden=".${kit}"
  mkdir -p "$tmp/$hidden/scripts" "$tmp/$hidden/templates"
  cp "$root/starter-kit-$kit/$hidden/scripts/bootstrap-runtime-state.sh" "$tmp/$hidden/scripts/"
  cp "$root/starter-kit-$kit/$hidden/templates/RUNTIME-STATE.md" "$tmp/$hidden/templates/"
  chmod +x "$tmp/$hidden/scripts/bootstrap-runtime-state.sh"
  (cd "$tmp" && bash "$hidden/scripts/bootstrap-runtime-state.sh")
  test -s "$tmp/$hidden/RUNTIME-STATE.md"
  ! grep -q 'A_COMPLETER' "$tmp/$hidden/RUNTIME-STATE.md"
  grep -q '^- goal_budget: 100000$' "$tmp/$hidden/RUNTIME-STATE.md"
  before="$(shasum -a 256 "$tmp/$hidden/RUNTIME-STATE.md" | awk '{print $1}')"
  (cd "$tmp" && bash "$hidden/scripts/bootstrap-runtime-state.sh") >/dev/null
  after="$(shasum -a 256 "$tmp/$hidden/RUNTIME-STATE.md" | awk '{print $1}')"
  test "$before" = "$after"
done
echo "Bootstrap runtime absent et idempotent Codex/Claude: OK"
