#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

for kit in codex claude; do
  hidden=".${kit}"
  mkdir -p "$tmp/$hidden/hooks" "$tmp/$hidden/scripts"
  cp "$root/starter-kit-$kit/$hidden/hooks/pre-tool-use.sh" "$tmp/$hidden/hooks/"
  cp "$root/starter-kit-$kit/$hidden/scripts/is-recovery-command.sh" "$tmp/$hidden/scripts/"
  touch "$tmp/$hidden/.session-kit-validated"
  git -C "$tmp" init -q

  for field in command cmd arguments.command arguments.cmd tool_input.command tool_input.cmd; do
    payload="$(jq -cn --arg field "$field" --arg value "bash .$kit/scripts/reconcile-runtime.sh" '
      {tool_name:"Bash"}
      + (reduce (($field | split("."))[]) as $part ({};
        .[$part] = (if $part == (($field | split(".")) | last) then $value else {} end)))')"
    if ! result="$(printf '%s' "$payload" | (cd "$tmp" && bash "$hidden/hooks/pre-tool-use.sh"))"; then
      echo "Le hook $kit échoue pour la forme $field" >&2
      exit 1
    fi
    if printf '%s' "$result" | jq -e '.hookSpecificOutput.permissionDecision == "deny"' >/dev/null; then
      echo "La forme $field est refusée à tort par le hook $kit" >&2
      exit 1
    fi
  done
done

echo "Formes d événements PreToolUse Codex/Claude: OK"
