#!/usr/bin/env bash
set -euo pipefail
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
for kit in codex claude; do
  hidden=".$kit"
  script="$root/starter-kit-$kit/$hidden/scripts/ensure-tools.sh"
  env_script="$root/starter-kit-$kit/$hidden/scripts/tool-env.sh"
  manifest="$root/starter-kit-$kit/$hidden/tool-manifest.tsv"
  bash -n "$script" "$env_script"
  bash -n "$root/starter-kit-$kit/.$kit/scripts/repair-git-index-lock.sh"
  bash -n "$root/starter-kit-$kit/.$kit/hooks/session-start.sh"
  grep -q 'AGENTIC_TOOLS_HOME' "$script"
  grep -q 'AGENTIC_NPM_PREFIX' "$script"
  grep -q -- '--python' "$script"
  grep -Fq 'npm\teslint' "$manifest"
  grep -Fq 'python\truff' "$manifest"
  test -f "$env_script"
done
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
AGENTIC_TOOLS_HOME="$tmp/tools" bash "$root/starter-kit-codex/.codex/scripts/ensure-tools.sh" git npm >/dev/null
AGENTIC_TOOLS_HOME="$tmp/tools" bash "$root/starter-kit-codex/.codex/scripts/ensure-tools.sh" --bootstrap >/dev/null
test -s "$tmp/tools/registry.tsv"
grep -Fq $'git\t' "$tmp/tools/registry.tsv"
grep -Fq $'npm\t' "$tmp/tools/registry.tsv"
git init -q "$tmp/repo"
git -C "$tmp/repo" checkout -q -b feat/lock-test
touch "$tmp/repo/.git/index.lock"
(cd "$tmp/repo" && bash "$root/starter-kit-codex/.codex/scripts/repair-git-index-lock.sh" >/dev/null)
test ! -e "$tmp/repo/.git/index.lock"
echo 'Registre central des outils OK'
